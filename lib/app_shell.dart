import 'package:flutter/material.dart';
import 'screens/contacts/contacts_page.dart';
import 'screens/first_aid.dart';
import 'screens/home/home_screen.dart';
import 'screens/settings/settings_page.dart';
import 'widgets/app_bottom_navigation_bar.dart';

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

  static const _navItems = [
    AppBottomNavigationItem(icon: Icons.home_rounded, label: 'Home'),
    AppBottomNavigationItem(
      icon: Icons.medical_services_rounded,
      label: 'First Aid',
    ),
    AppBottomNavigationItem(
      icon: Icons.contact_phone_rounded,
      label: 'Contact',
    ),
    AppBottomNavigationItem(icon: Icons.settings_rounded, label: 'Setting'),
  ];

  void _onDestinationSelected(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  Widget _pageForIndex(int index) {
    return switch (index) {
      0 => const HomePage(),
      1 => const ExplorePage(key: ValueKey<int>(1)),
      2 => const ContactsPage(key: ValueKey<int>(2)),
      3 => const SettingsPage(key: ValueKey<int>(3)),
      _ => const HomePage(),
    };
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
              child: _pageForIndex(_selectedIndex),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBottomNavigationBar(
              currentIndex: _selectedIndex,
              items: _navItems,
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
