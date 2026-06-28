import 'package:flutter/material.dart';
import 'emergency_contacts_screen.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: const SafeArea(bottom: false, child: EmergencyContactsScreen()),
    );
  }
}
