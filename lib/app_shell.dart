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
    AppBottomNavigationItem(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  void _onDestinationSelected(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  Widget _pageForIndex(int index) {
    return switch (index) {
      0 => const HomePage(),
      1 => const FirstAidPage(key: ValueKey<int>(1)),
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
