import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_preferences_provider.dart';
import 'widgets/profile_header.dart';
import 'widgets/preferences_panel.dart';
import 'widgets/emergency_form.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _bloodTypeController;
  late TextEditingController _allergiesController;
  late TextEditingController _emergencyContactController;

  @override
  void initState() {
    super.initState();
    final initialPrefs = Provider.of<AppPreferencesProvider>(context, listen: false);
    _nameController = TextEditingController(text: initialPrefs.userName);
    _bloodTypeController = TextEditingController(text: initialPrefs.bloodType);
    _allergiesController = TextEditingController(text: initialPrefs.allergies);
    _emergencyContactController = TextEditingController(text: initialPrefs.emergencyContact);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bloodTypeController.dispose();
    _allergiesController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<AppPreferencesProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          prefs.translate('Settings', 'ការកំណត់'),
          style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 24),
        ),
        backgroundColor: const Color(0xFFDC2626),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SettingsProfileHeader(userName: prefs.userName),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prefs.translate('App Preferences', 'ការកំណត់កម្មវិធី'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  
                  AppPreferencesPanel(
                    isKhmerSelected: prefs.isKhmerSelected,
                    isDarkMode: prefs.isDarkMode,
                    isLocationSharing: prefs.isLocationSharing,
                    onLanguageChanged: (val) => prefs.toggleLanguage(val),
                    onDarkModeChanged: (val) => prefs.toggleDarkMode(val),
                    onLocationChanged: (val) => prefs.toggleLocationSharing(val),
                  ),
                  const SizedBox(height: 28),

                  EmergencyProfileForm(
                    nameController: _nameController,
                    bloodTypeController: _bloodTypeController,
                    allergiesController: _allergiesController,
                    emergencyContactController: _emergencyContactController,
                    onSave: () {
                      prefs.saveMedicalId(
                        name: _nameController.text,
                        blood: _bloodTypeController.text,
                        allergyNotes: _allergiesController.text,
                        contact: _emergencyContactController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF10B981),
                          content: Text(prefs.translate('Profile Saved!', 'បានរក្សាទុកប្រវត្តិរូបសង្ខេប!')),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 140),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}