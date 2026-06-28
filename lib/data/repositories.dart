import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/emergency_contact.dart';

/// Exception class for network and API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException({required this.message, this.statusCode, this.originalError});

  bool get isRetryable =>
      statusCode == null ||
      statusCode == 408 ||
      statusCode == 429 ||
      statusCode == 500 ||
      statusCode == 502 ||
      statusCode == 503;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Abstract repository interface for contacts
abstract class ContactRepository {
  /// Fetch global emergency contacts (cached in app)
  Future<List<EmergencyContact>> fetchGlobalContacts({
    String? category,
    String countryCode = 'KH',
  });

  /// Fetch user's custom contacts (family, friends)
  Future<List<EmergencyContact>> fetchUserContacts();

  /// Add a custom contact
  Future<EmergencyContact> addCustomContact(EmergencyContact contact);

  /// Delete a custom contact
  Future<void> deleteCustomContact(String contactId);
}

/// Implementation of ContactRepository with API + local caching
class ContactRepositoryImpl extends ContactRepository {
  final String apiBaseUrl;
  final String? authToken;
  final ContactCache cache;

  /// Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(milliseconds: 100);

  ContactRepositoryImpl({
    required this.apiBaseUrl,
    this.authToken,
    required this.cache,
  });

  /// Helper: Make HTTP request with retry logic
  Future<http.Response> _retryableRequest(
    Future<http.Response> Function() request,
  ) async {
    int attempt = 0;
    Duration delay = retryDelay;

    while (attempt < maxRetries) {
      try {
        final response = await request();

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }

        // Check if error is retryable
        if (response.statusCode >= 500 || response.statusCode == 429) {
          if (attempt < maxRetries - 1) {
            await Future.delayed(delay);
            delay *= 2; // Exponential backoff
            attempt++;
            continue;
          }
        }

        throw ApiException(
          message: 'HTTP ${response.statusCode}: ${response.body}',
          statusCode: response.statusCode,
        );
      } on SocketException catch (e) {
        if (attempt < maxRetries - 1) {
          await Future.delayed(delay);
          delay *= 2;
          attempt++;
          continue;
        }
        throw ApiException(
          message: 'Network error: ${e.message}',
          originalError: e,
        );
      }
    }

    throw ApiException(message: 'Max retries exceeded');
  }

  /// Helper: Add auth headers
  Map<String, String> _getHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    return headers;
  }

  @override
  Future<List<EmergencyContact>> fetchGlobalContacts({
    String? category,
    String countryCode = 'KH',
  }) async {
    // Check cache first
    final cached = await cache.getGlobalContacts();
    if (cached != null && cached.isNotEmpty) {
      // If cache is valid, return it immediately while refreshing in background
      _refreshGlobalContactsInBackground(countryCode: countryCode);
      return cached;
    }

    // Fetch from API
    try {
      final queryParameters = <String, String>{'country': countryCode};
      if (category != null) {
        queryParameters['category'] = category;
      }
      final uri = Uri.parse(
        '$apiBaseUrl/contacts',
      ).replace(queryParameters: queryParameters);

      final response = await _retryableRequest(
        () => http.get(uri, headers: _getHeaders()),
      );

      final List<dynamic> data = jsonDecode(response.body);
      final contacts = data
          .map((json) => EmergencyContact.fromJson(json))
          .toList();

      // Cache for future use
      await cache.saveGlobalContacts(contacts);

      return contacts;
    } catch (e) {
      // Fall back to cache on error
      final cached = await cache.getGlobalContacts();
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }
      rethrow;
    }
  }

  /// Refresh global contacts in background without blocking
  Future<void> _refreshGlobalContactsInBackground({
    String countryCode = 'KH',
  }) async {
    try {
      await fetchGlobalContacts(countryCode: countryCode);
    } catch (e) {
      debugPrint('Background refresh failed: $e');
    }
  }

  @override
  Future<List<EmergencyContact>> fetchUserContacts() async {
    if (authToken == null) {
      throw ApiException(message: 'Not authenticated');
    }

    try {
      final uri = Uri.parse('$apiBaseUrl/user-contacts');
      final response = await _retryableRequest(
        () => http.get(uri, headers: _getHeaders()),
      );

      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => EmergencyContact.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to fetch user contacts: $e');
      rethrow;
    }
  }

  @override
  Future<EmergencyContact> addCustomContact(EmergencyContact contact) async {
    if (authToken == null) {
      throw ApiException(message: 'Not authenticated');
    }

    try {
      final uri = Uri.parse('$apiBaseUrl/user-contacts');
      final response = await _retryableRequest(
        () => http.post(
          uri,
          headers: _getHeaders(),
          body: jsonEncode(contact.toJson()),
        ),
      );

      final json = jsonDecode(response.body);
      return EmergencyContact.fromJson(json);
    } catch (e) {
      debugPrint('Failed to add contact: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteCustomContact(String contactId) async {
    if (authToken == null) {
      throw ApiException(message: 'Not authenticated');
    }

    try {
      final uri = Uri.parse('$apiBaseUrl/user-contacts/$contactId');
      await _retryableRequest(() => http.delete(uri, headers: _getHeaders()));
    } catch (e) {
      debugPrint('Failed to delete contact: $e');
      rethrow;
    }
  }
}

/// Local caching layer (use Hive or SQLite in production)
abstract class ContactCache {
  Future<List<EmergencyContact>?> getGlobalContacts();
  Future<void> saveGlobalContacts(List<EmergencyContact> contacts);
  Future<void> clearGlobalContacts();
}

/// In-memory cache implementation (for demo; use Hive in production)
class InMemoryContactCache implements ContactCache {
  List<EmergencyContact>? _globalContacts;
  DateTime? _cachedAt;

  static const cacheDuration = Duration(hours: 24);

  @override
  Future<List<EmergencyContact>?> getGlobalContacts() async {
    if (_globalContacts == null) return null;

    // Check if cache is still valid
    if (_cachedAt != null &&
        DateTime.now().difference(_cachedAt!).inHours < 24) {
      return _globalContacts;
    }

    // Cache expired
    _globalContacts = null;
    _cachedAt = null;
    return null;
  }

  @override
  Future<void> saveGlobalContacts(List<EmergencyContact> contacts) async {
    _globalContacts = contacts;
    _cachedAt = DateTime.now();
  }

  @override
  Future<void> clearGlobalContacts() async {
    _globalContacts = null;
    _cachedAt = null;
  }
}

/// Emergency dispatch repository
abstract class EmergencyRepository {
  /// Trigger an SOS alert
  Future<EmergencyReportResponse> triggerSOS({
    required double latitude,
    required double longitude,
    int? accuracy,
  });

  /// Check status of an SOS report
  Future<EmergencyReportStatus> checkReportStatus(String reportId);

  /// Cancel an SOS alert (false alarm)
  Future<void> cancelSOS(String reportId);
}

/// Response from SOS trigger
class EmergencyReportResponse {
  final String reportId;
  final String status; // 'pending', 'dispatched', etc.
  final int notifiedContacts;

  EmergencyReportResponse({
    required this.reportId,
    required this.status,
    required this.notifiedContacts,
  });

  factory EmergencyReportResponse.fromJson(Map<String, dynamic> json) =>
      EmergencyReportResponse(
        reportId: json['reportId'],
        status: json['status'],
        notifiedContacts: json['notifiedContacts'],
      );
}

/// Status of an emergency report
class EmergencyReportStatus {
  final String id;
  final String status;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  EmergencyReportStatus({
    required this.id,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.resolvedAt,
  });

  factory EmergencyReportStatus.fromJson(Map<String, dynamic> json) =>
      EmergencyReportStatus(
        id: json['id'],
        status: json['status'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        createdAt: DateTime.parse(json['created_at']),
        resolvedAt: json['resolved_at'] != null
            ? DateTime.parse(json['resolved_at'])
            : null,
      );
}

/// Implementation of EmergencyRepository
class EmergencyRepositoryImpl extends EmergencyRepository {
  final String apiBaseUrl;
  final String? authToken;
  final ContactRepository contactRepository;

  EmergencyRepositoryImpl({
    required this.apiBaseUrl,
    this.authToken,
    required this.contactRepository,
  });

  Map<String, String> _getHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  @override
  Future<EmergencyReportResponse> triggerSOS({
    required double latitude,
    required double longitude,
    int? accuracy,
  }) async {
    if (authToken == null) {
      throw ApiException(message: 'Not authenticated');
    }

    try {
      final requestBody = <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
      };
      if (accuracy != null) {
        requestBody['accuracy'] = accuracy;
      }
      final uri = Uri.parse('$apiBaseUrl/emergency/sos');
      final response = await http.post(
        uri,
        headers: _getHeaders(),
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200) {
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }

      final json = jsonDecode(response.body);
      return EmergencyReportResponse.fromJson(json);
    } catch (e) {
      debugPrint('SOS trigger failed: $e');
      rethrow;
    }
  }

  @override
  Future<EmergencyReportStatus> checkReportStatus(String reportId) async {
    if (authToken == null) {
      throw ApiException(message: 'Not authenticated');
    }

    try {
      final uri = Uri.parse('$apiBaseUrl/emergency/report/$reportId');
      final response = await http.get(uri, headers: _getHeaders());

      if (response.statusCode != 200) {
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }

      final json = jsonDecode(response.body);
      return EmergencyReportStatus.fromJson(json);
    } catch (e) {
      debugPrint('Status check failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> cancelSOS(String reportId) async {
    if (authToken == null) {
      throw ApiException(message: 'Not authenticated');
    }

    try {
      final uri = Uri.parse('$apiBaseUrl/emergency/report/$reportId/cancel');
      final response = await http.put(uri, headers: _getHeaders());

      if (response.statusCode != 200) {
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('SOS cancel failed: $e');
      rethrow;
    }
  }
}

// Socket exception (for network errors)
class SocketException implements Exception {
  final String message;
  SocketException(this.message);
}
