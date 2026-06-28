import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../../models/emergency_contact.dart';
import '../../providers/app_preferences_provider.dart';
import '../contacts/contact_list_screen.dart';
import '../../widgets/animated_sos_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prefs = context.watch<AppPreferencesProvider>();
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -50,
            child: _buildGlow(
              Colors.red.withValues(alpha: isDark ? 0.05 : 0.08),
            ),
          ),
          Positioned(
            bottom: 50,
            left: -100,
            child: _buildGlow(
              Colors.blue.withValues(alpha: isDark ? 0.05 : 0.06),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: math.max(0, constraints.maxHeight - 40),
                    ),
                    child: Column(
                      children: [
                        _buildHeader(
                          prefs.userName,
                          prefs.translate('Welcome,', 'សូមស្វាគមន៍,'),
                          textColor,
                        ),
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            prefs.translate(
                              'Emergency Assistance',
                              'ជំនួយបន្ទាន់',
                            ),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildCategoryGrid(context, prefs, textColor),
                        const SizedBox(height: 40),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              prefs.translate(
                                'Are you in emergency?',
                                'តើអ្នកកំពុងជួបប្រទះគ្រោះថ្នាក់?',
                              ),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 40),
                            const AnimatedSOSButton(),
                          ],
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlow(Color color) {
    return Container(
      height: 400,
      width: 400,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildHeader(String userName, String welcomeText, Color textColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.redAccent, width: 2),
          ),
          child: const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 30, color: Colors.grey),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              welcomeText,
              style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
            ),
            Text(
              userName.toUpperCase(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(
    BuildContext context,
    AppPreferencesProvider prefs,
    Color textColor,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 0.75,
      children: [
        _buildCategoryTile(
          context,
          Icons.local_fire_department_rounded,
          prefs.translate('Fire', 'អគ្គិភ័យ'),
          ContactCategory.fire,
          textColor,
        ),
        _buildCategoryTile(
          context,
          Icons.local_police_rounded,
          prefs.translate('Police', 'ប៉ូលិស'),
          ContactCategory.police,
          textColor,
        ),
        _buildCategoryTile(
          context,
          Icons.groups_rounded,
          prefs.translate('Family', 'គ្រួសារ'),
          ContactCategory.family,
          textColor,
        ),
        _buildCategoryTile(
          context,
          Icons.car_crash_rounded,
          prefs.translate('Accident', 'គ្រោះថ្នាក់'),
          ContactCategory.roadSafety,
          textColor,
        ),
        _buildCategoryTile(
          context,
          Icons.medical_services_rounded,
          prefs.translate('Medical', 'វេជ្ជសាស្ត្រ'),
          ContactCategory.medical,
          textColor,
        ),
        _buildCategoryTile(
          context,
          Icons.traffic_rounded,
          prefs.translate('Road', 'ផ្លូវ'),
          ContactCategory.roadSafety,
          textColor,
        ),
      ],
    );
  }

  Widget _buildCategoryTile(
    BuildContext context,
    IconData icon,
    String label,
    ContactCategory category,
    Color textColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContactListScreen(category: category),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.redAccent),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
