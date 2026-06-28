import 'package:flutter/material.dart';

class AppPreferencesProvider with ChangeNotifier {
  bool _isKhmerSelected = false;
  bool _isDarkMode = false;
  bool _isLocationSharing = true;

  // Medical Card ICE States
  String _userName = "Sophat Phorn";
  String _bloodType = "AB+";
  String _allergies = "None";
  String _emergencyContact = "012 345 678";

  // Getters
  bool get isKhmerSelected => _isKhmerSelected;
  bool get isDarkMode => _isDarkMode;
  bool get isLocationSharing => _isLocationSharing;
  Locale get locale =>
      _isKhmerSelected ? const Locale('km') : const Locale('en');

  String get userName => _userName;
  String get bloodType => _bloodType;
  String get allergies => _allergies;
  String get emergencyContact => _emergencyContact;

  // Setters / Toggles
  void toggleLanguage(bool isKhmer) {
    _isKhmerSelected = isKhmer;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void toggleLocationSharing(bool value) {
    _isLocationSharing = value;
    notifyListeners();
  }

  void saveMedicalId({
    required String name,
    required String blood,
    required String allergyNotes,
    required String contact,
  }) {
    _userName = name;
    _bloodType = blood;
    _allergies = allergyNotes;
    _emergencyContact = contact;
    notifyListeners();
  }

  // Quick Localization Translation Helper
  String translate(String englishText, String khmerText) {
    return _isKhmerSelected ? khmerText : englishText;
  }
}
