import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/app_bottom_navigation_bar.dart';
import 'screens/first_aid.dart';
import 'screens/settings/settings_page.dart';
import 'screens/contacts/contacts_page.dart';
import 'providers/app_preferences_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppPreferencesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<AppPreferencesProvider>(context);

    return MaterialApp(
      title: 'Emergency App',
      debugShowCheckedModeBanner: false,
      themeMode: prefs.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFDC2626),
          brightness: Brightness.light,
          primary: const Color(0xFFDC2626),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8F8),
        cardColor: Colors.white,
        dividerColor: const Color(0xFFF1F5F9),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFEF4444),
          secondary: Color(0xFFF97316),
          surface: Color(0xFF1E293B),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardColor: const Color(0xFF1E293B),
        dividerColor: const Color(0xFF334155),
        hintColor: const Color(0xFF94A3B8),
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
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPageForIndex(int index) {
    switch (index) {
      case 1:
        return const ExplorePage(key: ValueKey<int>(1));
      case 2:
        return const ContactsPage(key: ValueKey<int>(2));
      case 3:
        return const SettingsPage(key: ValueKey<int>(3));
      default:
        return _DashboardPage(key: ValueKey<int>(index), data: _pages[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutQuint,
              switchOutCurve: Curves.easeInQuad,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.96, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutQuint,
                      ),
                    ),
                    child: child,
                  ),
                );
              },
              child: _getPageForIndex(_selectedIndex),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBottomNavigationBar(
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
          ),
        ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [const Color(0xFFF8FAFC), const Color(0xFFF1F5F9)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
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
                          color: data.color.withOpacity(0.12),
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
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data.title,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: isDark
                                        ? const Color(0xFFF8FAFC)
                                        : const Color(0xFF0F172A),
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
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 28,
                          offset: Offset(0, 16),
                        ),
                      ],
                      border: Border.all(color: Theme.of(context).dividerColor),
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
                            color: data.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Active section',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: data.color,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          data.subtitle,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                height: 1.5,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF475569),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 104,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: tint.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: tint, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
