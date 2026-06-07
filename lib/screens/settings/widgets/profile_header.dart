import 'package:flutter/material.dart';

class SettingsProfileHeader extends StatelessWidget {
  final String userName;

  const SettingsProfileHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: const Color(0xFFDC2626),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: const Color(0xFFDC2626).withOpacity(0.1),
              child: const Icon(Icons.person, size: 36, color: Color(0xFFDC2626)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName.isNotEmpty ? userName : 'User Profile',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.w800, 
                      color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'ICE Emergency Card Active',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFDC2626)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}