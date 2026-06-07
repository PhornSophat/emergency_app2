import 'package:flutter/material.dart';
import 'emergency_contacts_screen.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F8),
      body: const EmergencyContactsScreen(),
    );
  }
}
