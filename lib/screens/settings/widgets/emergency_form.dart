import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_preferences_provider.dart';

class EmergencyProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController bloodTypeController;
  final TextEditingController allergiesController;
  final TextEditingController emergencyContactController;
  final VoidCallback onSave;

  const EmergencyProfileForm({
    super.key,
    required this.nameController,
    required this.bloodTypeController,
    required this.allergiesController,
    required this.emergencyContactController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final prefs = context.watch<AppPreferencesProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          _buildFormInputField(
            context: context,
            label: prefs.translate('Full Name', 'ឈ្មោះពេញ'),
            controller: nameController,
            icon: Icons.badge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFormInputField(
                  context: context,
                  label: prefs.translate('Blood Type', 'ក្រុមឈាម'),
                  controller: bloodTypeController,
                  icon: Icons.bloodtype,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFormInputField(
                  context: context,
                  label: prefs.translate('ICE Contact', 'ទំនាក់ទំនង ICE'),
                  controller: emergencyContactController,
                  icon: Icons.phone,
                  isPhone: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormInputField(
            context: context,
            label: prefs.translate(
              'Known Allergies / Medical Notes',
              'ប្រវត្តិអាឡែស៊ី / កំណត់សម្គាល់វេជ្ជសាស្ត្រ',
            ),
            controller: allergiesController,
            icon: Icons.warning_amber_rounded,
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                elevation: isDark ? 4 : 0,
                shadowColor: const Color(0xFFDC2626).withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                prefs.translate(
                  'Save Profile Details',
                  'រក្សាទុកព័ត៌មានប្រវត្តិរូប',
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormInputField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPhone = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFFEF4444).withValues(alpha: 0.8),
          size: 20,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
      ),
    );
  }
}
