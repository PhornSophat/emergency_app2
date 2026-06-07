import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.home_rounded,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency App',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Home',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0F172A),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Welcome Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 28,
                        offset: Offset(0, 16),
                      ),
                    ],
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFDC2626,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Welcome',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: const Color(0xFFDC2626),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Fast access to emergency tools and key actions.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                          color: const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 22),
                      // Quick Action Cards
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: const [
                          _QuickActionCard(
                            title: 'SOS',
                            subtitle: 'Instant call',
                            icon: Icons.warning_rounded,
                            tint: Color(0xFFDC2626),
                          ),
                          _QuickActionCard(
                            title: 'Contacts',
                            subtitle: 'Trusted people',
                            icon: Icons.groups_rounded,
                            tint: Color(0xFF0F766E),
                          ),
                          _QuickActionCard(
                            title: 'Location',
                            subtitle: 'Share live map',
                            icon: Icons.my_location_rounded,
                            tint: Color(0xFF334155),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tint.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: tint),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF0F172A),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF64748B),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
