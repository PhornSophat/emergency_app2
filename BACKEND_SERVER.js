import express from 'express';
import { Pool } from 'pg';
import jwt from 'jsonwebtoken';
import rateLimit from 'express-rate-limit';
import cors from 'cors';
import helmet from 'helmet';
import dotenv from 'dotenv';
import winston from 'winston';
import { Server as SocketIOServer } from 'socket.io';
import http from 'http';

dotenv.config();

// ═══════════════════════════════════════════════════════════════════════════
// LOGGER SETUP
// ═══════════════════════════════════════════════════════════════════════════

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.json(),
  defaultMeta: { service: 'emergency-app-api' },
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
    ...(process.env.NODE_ENV !== 'production'
      ? [new winston.transports.Console({ format: winston.format.simple() })]
      : []),
  ],
});

// ═══════════════════════════════════════════════════════════════════════════
// DATABASE SETUP
// ═══════════════════════════════════════════════════════════════════════════

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

pool.on('error', (err) => {
  logger.error('Unexpected error on idle client', err);
});

// Initialize database tables on startup
async function initDatabase() {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS users (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        phone_number VARCHAR(20) UNIQUE NOT NULL,
        name VARCHAR(255),
        blood_type VARCHAR(10),
        allergies TEXT,
        emergency_contact_phone VARCHAR(20),
        location_sharing_enabled BOOLEAN DEFAULT FALSE,
        country_code VARCHAR(2) DEFAULT 'KH',
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
      );

      CREATE TABLE IF NOT EXISTS user_contacts (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        user_id UUID REFERENCES users(id) ON DELETE CASCADE,
        name VARCHAR(255) NOT NULL,
        phone VARCHAR(20) NOT NULL,
        category VARCHAR(50) NOT NULL,
        address TEXT,
        hours VARCHAR(100),
        image_url TEXT,
        is_custom BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT NOW()
      );

      CREATE TABLE IF NOT EXISTS emergency_contacts_global (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        name VARCHAR(255) NOT NULL,
        phone VARCHAR(20) NOT NULL,
        category VARCHAR(50) NOT NULL,
        address TEXT,
        hours VARCHAR(100),
        image_url TEXT,
        country_code VARCHAR(2),
        created_at TIMESTAMP DEFAULT NOW()
      );

      CREATE TABLE IF NOT EXISTS emergency_reports (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        user_id UUID REFERENCES users(id),
        latitude DECIMAL(10, 8) NOT NULL,
        longitude DECIMAL(11, 8) NOT NULL,
        accuracy INT,
        status VARCHAR(50) DEFAULT 'pending',
        notified_contacts TEXT,
        created_at TIMESTAMP DEFAULT NOW(),
        resolved_at TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS audit_logs (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        user_id UUID REFERENCES users(id),
        action VARCHAR(255),
        details JSONB,
        created_at TIMESTAMP DEFAULT NOW()
      );

      CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone_number);
      CREATE INDEX IF NOT EXISTS idx_emergency_reports_user ON emergency_reports(user_id);
      CREATE INDEX IF NOT EXISTS idx_emergency_reports_status ON emergency_reports(status);
      CREATE INDEX IF NOT EXISTS idx_user_contacts_user ON user_contacts(user_id);
      CREATE INDEX IF NOT EXISTS idx_audit_logs_user ON audit_logs(user_id);
    `);
    logger.info('Database initialized successfully');
  } catch (err) {
    logger.error('Database initialization failed', err);
    process.exit(1);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EXPRESS APP SETUP
// ═══════════════════════════════════════════════════════════════════════════

const app = express();
const server = http.createServer(app);
const io = new SocketIOServer(server, {
  cors: { origin: process.env.CORS_ORIGIN || '*' },
});

// Security middleware
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '10mb' }));

// Rate limiting
const limiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 1000, // 1000 requests per minute per IP
  message: 'Too many requests from this IP, please try again later.',
  standardHeaders: true,
  legacyHeaders: false,
});

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 attempts per 15 minutes
  skipSuccessfulRequests: true,
});

app.use('/api/v1/', limiter);
app.use('/api/v1/auth/login', authLimiter);

// ═══════════════════════════════════════════════════════════════════════════
// UTILITY FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════

function generateToken(userId) {
  return jwt.sign({ id: userId }, process.env.JWT_SECRET, {
    expiresIn: '30d',
  });
}

function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    logger.warn('Missing token in request');
    return res.status(401).json({ error: 'Unauthorized' });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      logger.warn('Invalid token', { error: err.message });
      return res.status(403).json({ error: 'Forbidden' });
    }
    req.user = user;
    next();
  });
}

async function logAudit(userId, action, details) {
  try {
    await pool.query(
      'INSERT INTO audit_logs (user_id, action, details) VALUES ($1, $2, $3)',
      [userId, action, JSON.stringify(details)]
    );
  } catch (err) {
    logger.error('Audit logging failed', { error: err.message, userId, action });
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HEALTH CHECK
// ═══════════════════════════════════════════════════════════════════════════

app.get('/api/v1/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});

// ═══════════════════════════════════════════════════════════════════════════
// AUTH ENDPOINTS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * POST /api/v1/auth/register
 * Register a new user with phone number
 */
app.post('/api/v1/auth/register', async (req, res) => {
  const { phoneNumber, name, countryCode } = req.body;

  if (!phoneNumber || phoneNumber.length < 7) {
    return res.status(400).json({ error: 'Invalid phone number' });
  }

  try {
    const client = await pool.connect();
    try {
      await client.query('BEGIN');

      // Insert user
      const result = await client.query(
        `INSERT INTO users (phone_number, name, country_code)
         VALUES ($1, $2, $3)
         ON CONFLICT (phone_number) DO UPDATE SET updated_at = NOW()
         RETURNING id, phone_number, name`,
        [phoneNumber, name || 'User', countryCode || 'KH']
      );

      const user = result.rows[0];
      const token = generateToken(user.id);

      await logAudit(user.id, 'user_registered', { phoneNumber });
      await client.query('COMMIT');

      res.status(201).json({
        id: user.id,
        phoneNumber: user.phone_number,
        name: user.name,
        token,
      });
    } catch (err) {
      await client.query('ROLLBACK');
      throw err;
    } finally {
      client.release();
    }
  } catch (err) {
    logger.error('Registration failed', { error: err.message, phoneNumber });
    res.status(500).json({ error: 'Registration failed' });
  }
});

/**
 * POST /api/v1/auth/login
 * Login with phone number (simplified for demo)
 */
app.post('/api/v1/auth/login', async (req, res) => {
  const { phoneNumber } = req.body;

  if (!phoneNumber) {
    return res.status(400).json({ error: 'Phone number required' });
  }

  try {
    const result = await pool.query(
      'SELECT id, phone_number, name FROM users WHERE phone_number = $1',
      [phoneNumber]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'User not found' });
    }

    const user = result.rows[0];
    const token = generateToken(user.id);

    await logAudit(user.id, 'user_login', { phoneNumber });

    res.json({
      id: user.id,
      phoneNumber: user.phone_number,
      name: user.name,
      token,
    });
  } catch (err) {
    logger.error('Login failed', { error: err.message, phoneNumber });
    res.status(500).json({ error: 'Login failed' });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// USER ENDPOINTS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * GET /api/v1/users/profile
 * Fetch user profile (ICE card)
 */
app.get('/api/v1/users/profile', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT id, phone_number, name, blood_type, allergies, 
              emergency_contact_phone, location_sharing_enabled, created_at
       FROM users WHERE id = $1`,
      [req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json(result.rows[0]);
  } catch (err) {
    logger.error('Profile fetch failed', { error: err.message, userId: req.user.id });
    res.status(500).json({ error: 'Profile fetch failed' });
  }
});

/**
 * PUT /api/v1/users/profile
 * Update user profile (ICE card)
 */
app.put('/api/v1/users/profile', authenticateToken, async (req, res) => {
  const { name, bloodType, allergies, emergencyContactPhone } = req.body;

  try {
    const result = await pool.query(
      `UPDATE users 
       SET name = COALESCE($1, name),
           blood_type = COALESCE($2, blood_type),
           allergies = COALESCE($3, allergies),
           emergency_contact_phone = COALESCE($4, emergency_contact_phone),
           updated_at = NOW()
       WHERE id = $5
       RETURNING id, name, blood_type, allergies, emergency_contact_phone`,
      [name, bloodType, allergies, emergencyContactPhone, req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    await logAudit(req.user.id, 'profile_updated', { fields: Object.keys(req.body) });

    res.json(result.rows[0]);
  } catch (err) {
    logger.error('Profile update failed', { error: err.message, userId: req.user.id });
    res.status(500).json({ error: 'Profile update failed' });
  }
});

/**
 * PUT /api/v1/users/location-sharing
 * Toggle location sharing consent
 */
app.put('/api/v1/users/location-sharing', authenticateToken, async (req, res) => {
  const { enabled } = req.body;

  try {
    await pool.query(
      'UPDATE users SET location_sharing_enabled = $1, updated_at = NOW() WHERE id = $2',
      [enabled, req.user.id]
    );

    await logAudit(req.user.id, 'location_sharing_toggled', { enabled });

    res.json({ locationSharingEnabled: enabled });
  } catch (err) {
    logger.error('Location sharing update failed', { error: err.message, userId: req.user.id });
    res.status(500).json({ error: 'Location sharing update failed' });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// CONTACTS ENDPOINTS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * GET /api/v1/contacts
 * Fetch global emergency contacts (cacheable: 24h in client)
 */
app.get('/api/v1/contacts', async (req, res) => {
  try {
    const countryCode = req.query.country || 'KH';
    const category = req.query.category;

    let query = 'SELECT * FROM emergency_contacts_global WHERE country_code = $1';
    const params = [countryCode];

    if (category) {
      query += ' AND category = $2';
      params.push(category);
    }

    query += ' ORDER BY category, name';

    const result = await pool.query(query, params);

    // Set cache headers (24 hours)
    res.set('Cache-Control', 'public, max-age=86400');
    res.set('ETag', `W/"${Buffer.from(JSON.stringify(result.rows)).toString('base64').substring(0, 27)}"`);

    res.json(result.rows);
  } catch (err) {
    logger.error('Contacts fetch failed', { error: err.message });
    res.status(500).json({ error: 'Contacts fetch failed' });
  }
});

/**
 * GET /api/v1/user-contacts
 * Fetch user's custom contacts (family, friends)
 */
app.get('/api/v1/user-contacts', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT id, name, phone, category, address FROM user_contacts WHERE user_id = $1 ORDER BY name',
      [req.user.id]
    );

    res.json(result.rows);
  } catch (err) {
    logger.error('User contacts fetch failed', { error: err.message, userId: req.user.id });
    res.status(500).json({ error: 'User contacts fetch failed' });
  }
});

/**
 * POST /api/v1/user-contacts
 * Add a new custom contact
 */
app.post('/api/v1/user-contacts', authenticateToken, async (req, res) => {
  const { name, phone, category, address } = req.body;

  if (!name || !phone || !category) {
    return res.status(400).json({ error: 'Name, phone, and category are required' });
  }

  try {
    const result = await pool.query(
      `INSERT INTO user_contacts (user_id, name, phone, category, address, is_custom)
       VALUES ($1, $2, $3, $4, $5, true)
       RETURNING id, name, phone, category, address`,
      [req.user.id, name, phone, category, address || null]
    );

    await logAudit(req.user.id, 'custom_contact_added', { name, phone, category });

    res.status(201).json(result.rows[0]);
  } catch (err) {
    logger.error('Contact creation failed', { error: err.message, userId: req.user.id });
    res.status(500).json({ error: 'Contact creation failed' });
  }
});

/**
 * DELETE /api/v1/user-contacts/:id
 * Delete a custom contact
 */
app.delete('/api/v1/user-contacts/:id', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'DELETE FROM user_contacts WHERE id = $1 AND user_id = $2 RETURNING id',
      [req.params.id, req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Contact not found' });
    }

    await logAudit(req.user.id, 'custom_contact_deleted', { contactId: req.params.id });

    res.json({ deleted: true });
  } catch (err) {
    logger.error('Contact deletion failed', { error: err.message, userId: req.user.id });
    res.status(500).json({ error: 'Contact deletion failed' });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// EMERGENCY ENDPOINTS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * POST /api/v1/emergency/sos
 * Trigger an SOS emergency alert
 */
app.post('/api/v1/emergency/sos', authenticateToken, async (req, res) => {
  const { latitude, longitude, accuracy } = req.body;

  if (!latitude || !longitude) {
    return res.status(400).json({ error: 'Latitude and longitude required' });
  }

  try {
    const client = await pool.connect();
    try {
      await client.query('BEGIN');

      // Create emergency report
      const reportResult = await client.query(
        `INSERT INTO emergency_reports (user_id, latitude, longitude, accuracy, status)
         VALUES ($1, $2, $3, $4, 'pending')
         RETURNING id, created_at`,
        [req.user.id, latitude, longitude, accuracy || null]
      );

      const reportId = reportResult.rows[0].id;

      // Fetch user's emergency contacts
      const contactsResult = await client.query(
        `SELECT id FROM user_contacts WHERE user_id = $1 AND category = 'family'
         UNION ALL
         SELECT id FROM emergency_contacts_global WHERE category = 'medical' LIMIT 3`,
        [req.user.id]
      );

      const notifiedContacts = contactsResult.rows.map((r) => r.id);

      // Update report with notified contacts
      await client.query(
        'UPDATE emergency_reports SET notified_contacts = $1 WHERE id = $2',
        [JSON.stringify(notifiedContacts), reportId]
      );

      // Log audit trail
      await client.query(
        'INSERT INTO audit_logs (user_id, action, details) VALUES ($1, $2, $3)',
        [
          req.user.id,
          'emergency_sos_triggered',
          JSON.stringify({ reportId, latitude, longitude, contactCount: notifiedContacts.length }),
        ]
      );

      await client.query('COMMIT');

      // Trigger async notifications (SMS, push, dispatch routing)
      // In production, use a job queue (Bull, RabbitMQ, etc.)
      setImmediate(() => {
        notifyEmergencyContacts(req.user.id, reportId, { latitude, longitude }, notifiedContacts);
        routeToDispatcher(latitude, longitude, req.user.id, reportId);
      });

      res.json({
        reportId,
        status: 'dispatched',
        notifiedContacts: notifiedContacts.length,
      });
    } catch (err) {
      await client.query('ROLLBACK');
      throw err;
    } finally {
      client.release();
    }
  } catch (err) {
    logger.error('SOS dispatch failed', { error: err.message, userId: req.user.id });
    res.status(500).json({ error: 'SOS dispatch failed' });
  }
});

/**
 * GET /api/v1/emergency/report/:id
 * Check status of an emergency report
 */
app.get('/api/v1/emergency/report/:id', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT id, status, latitude, longitude, created_at, resolved_at
       FROM emergency_reports
       WHERE id = $1 AND user_id = $2`,
      [req.params.id, req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Report not found' });
    }

    res.json(result.rows[0]);
  } catch (err) {
    logger.error('Report fetch failed', { error: err.message, userId: req.user.id });
    res.status(500).json({ error: 'Report fetch failed' });
  }
});

/**
 * PUT /api/v1/emergency/report/:id/cancel
 * Cancel an SOS alert (false alarm)
 */
app.put('/api/v1/emergency/report/:id/cancel', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      `UPDATE emergency_reports
       SET status = 'cancelled', resolved_at = NOW()
       WHERE id = $1 AND user_id = $2
       RETURNING id, status`,
      [req.params.id, req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Report not found' });
    }

    await logAudit(req.user.id, 'emergency_sos_cancelled', { reportId: req.params.id });

    res.json(result.rows[0]);
  } catch (err) {
    logger.error('Cancel SOS failed', { error: err.message, userId: req.user.id });
    res.status(500).json({ error: 'Cancel SOS failed' });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// FIRST AID GUIDES (Optional: can be hardcoded in app or fetched from backend)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * GET /api/v1/guides
 * Fetch all first-aid guides
 */
app.get('/api/v1/guides', (req, res) => {
  // In production, fetch from DB or CMS
  res.set('Cache-Control', 'public, max-age=604800'); // 7 days
  res.json([
    {
      id: 'cpr-drsabcd',
      title: 'DRSABCD Response Plan',
      category: 'Life-Threatening',
      steps: [
        'Danger: Ensure the area is safe',
        'Response: Check if patient is conscious',
        'Send: Call emergency services immediately (119)',
        'Airway: Open the mouth and check for blockages',
        'Breathing: Look, listen, and feel for normal breathing',
        'CPR: Start cycles of 30 chest compressions and 2 rescue breaths',
        'Defibrillation: Attach an AED and follow voice prompts',
      ],
      youtubeUrl: 'https://www.youtube.com/watch?v=8MOPr4moad4',
    },
    // ... more guides
  ]);
});

// ═══════════════════════════════════════════════════════════════════════════
// ASYNC FUNCTIONS (Background Tasks)
// ═══════════════════════════════════════════════════════════════════════════

async function notifyEmergencyContacts(userId, reportId, location, contactIds) {
  // In production: send SMS/push notifications to contacts
  // Example integration:
  // - Twilio for SMS
  // - Firebase Cloud Messaging for push
  // - WebSocket broadcast via Socket.io for real-time updates

  logger.info('Emergency contacts notified', {
    userId,
    reportId,
    contactCount: contactIds.length,
  });

  // Broadcast via WebSocket
  io.emit('emergency_alert', {
    reportId,
    userId,
    location,
    timestamp: new Date(),
  });
}

async function routeToDispatcher(latitude, longitude, userId, reportId) {
  // In production: integrate with dispatch system (e.g., Mapbox Directions API)
  // Find nearest ambulance/fire station and route to location

  logger.info('SOS routed to dispatcher', {
    latitude,
    longitude,
    userId,
    reportId,
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// SOCKET.IO (Optional: Real-time location streaming)
// ═══════════════════════════════════════════════════════════════════════════

io.on('connection', (socket) => {
  logger.info('Client connected via WebSocket', { socketId: socket.id });

  socket.on('location_update', (data) => {
    // Broadcast user's location to family/dispatcher
    io.emit('location_updated', {
      userId: data.userId,
      latitude: data.latitude,
      longitude: data.longitude,
      timestamp: Date.now(),
    });
  });

  socket.on('disconnect', () => {
    logger.info('Client disconnected', { socketId: socket.id });
  });
});

// ═══════════════════════════════════════════════════════════════════════════
// ERROR HANDLING
// ═══════════════════════════════════════════════════════════════════════════

app.use((err, req, res, next) => {
  logger.error('Unhandled error', { error: err.message, stack: err.stack });
  res.status(500).json({ error: 'Internal server error' });
});

app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

// ═══════════════════════════════════════════════════════════════════════════
// SERVER STARTUP
// ═══════════════════════════════════════════════════════════════════════════

const PORT = process.env.PORT || 3000;

async function start() {
  await initDatabase();

  server.listen(PORT, () => {
    logger.info(`Server running on port ${PORT}`);
  });
}

start().catch((err) => {
  logger.error('Failed to start server', err);
  process.exit(1);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  logger.info('SIGTERM signal received: closing HTTP server');
  server.close(async () => {
    await pool.end();
    logger.info('HTTP server closed, database pool closed');
    process.exit(0);
  });
});

export default app;
