import 'package:flutter/material.dart';
import '../../widgets/app_bottom_navigation_bar.dart';

class NavConfig {
  static const List<AppBottomNavigationItem> navItems = [
    AppBottomNavigationItem(
      icon: Icons.home_rounded,
      label: 'Home',
      khmerLabel: 'ទំព័រដើម',
    ),
    AppBottomNavigationItem(
      icon: Icons.medical_services_rounded,
      label: 'First Aid',
      khmerLabel: 'បឋមព្យាបាល',
    ),
    AppBottomNavigationItem(
      icon: Icons.contact_phone_rounded,
      label: 'Contact',
      khmerLabel: 'ទំនាក់ទំនង',
    ),
    AppBottomNavigationItem(
      icon: Icons.settings_rounded,
      label: 'Setting',
      khmerLabel: 'ការកំណត់',
    ),
  ];
}
