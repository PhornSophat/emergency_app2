import 'package:flutter/material.dart';
import '../../widgets/app_bottom_navigation_bar.dart';

class NavConfig {
  static const List<AppBottomNavigationItem> navItems = [
    AppBottomNavigationItem(icon: Icons.home_rounded, label: 'Home'),
    AppBottomNavigationItem(icon: Icons.medical_services_rounded, label: 'First Aid'),
    AppBottomNavigationItem(icon: Icons.contact_phone_rounded, label: 'Contact'),
    AppBottomNavigationItem(icon: Icons.settings_rounded, label: 'Setting'),
  ];
}