import 'package:flutter/material.dart';

import 'widgets/app_bottom_navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFDC2626),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const List<_NavPage> _pages = [
    _NavPage(
      title: 'Home',
      subtitle: 'Fast access to emergency tools and key actions.',
      color: Color(0xFFDC2626),
      icon: Icons.home_rounded,
    ),
    _NavPage(
      title: 'First Aid',
      subtitle: 'Quick guides and emergency care steps for urgent cases.',
      color: Color(0xFFF97316),
      icon: Icons.medical_services_rounded,
    ),
    _NavPage(
      title: 'Contact',
      subtitle: 'Reach trusted people and emergency services quickly.',
      color: Color(0xFF0F766E),
      icon: Icons.contact_phone_rounded,
    ),
    _NavPage(
      title: 'Setting',
      subtitle: 'Customize alerts, contacts, and app preferences.',
      color: Color(0xFF334155),
      icon: Icons.settings_rounded,
    ),
  ];

  void _onDestinationSelected(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final slideAnimation = Tween<Offset>(
                    begin: const Offset(0.04, 0.02),
                    end: Offset.zero,
                  ).animate(animation);

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: slideAnimation, child: child),
                  );
                },
                child: _DashboardPage(
                  key: ValueKey<int>(_selectedIndex),
                  data: _pages[_selectedIndex],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          AppBottomNavigationItem(
            icon: Icons.home_rounded,
            label: 'Home',
          ),
          AppBottomNavigationItem(
            icon: Icons.medical_services_rounded,
            label: 'First Aid',
          ),
          AppBottomNavigationItem(
            icon: Icons.contact_phone_rounded,
            label: 'Contact',
          ),
          AppBottomNavigationItem(
            icon: Icons.settings_rounded,
            label: 'Setting',
          ),
        ],
        onTap: _onDestinationSelected,
      ),
    );
  }
}

class _NavPage {
  const _NavPage({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage({super.key, required this.data});

  final _NavPage data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 420;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: data.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(data.icon, color: data.color),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency App',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.title,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  width: double.infinity,
                  padding: EdgeInsets.all(isCompact ? 18 : 22),
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
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: data.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Active section',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: data.color,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        data.subtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.5,
                              color: const Color(0xFF475569),
                            ),
                      ),
                      const SizedBox(height: 22),
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
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: Text(
                      'Tap the bottom menu to switch pages with a smooth animated transition.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF64748B),
                            height: 1.5,
                          ),
                    ),
                  ),
                ),
              ],
            );
          },
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
      width: 104,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: tint, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF64748B),
                ),
          ),
        ],
      ),
    );
  }
}
