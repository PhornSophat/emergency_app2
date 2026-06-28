import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/nav_items.dart';
import 'providers/app_preferences_provider.dart';
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
    final prefs = context.watch<AppPreferencesProvider>();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _pageForIndex(_selectedIndex)),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBottomNavigationBar(
              currentIndex: _selectedIndex,
              items: NavConfig.navItems,
              isKhmerSelected: prefs.isKhmerSelected,
              onTap: _onDestinationSelected,
            ),
          ),
        ],
      ),
    );
  }
}
