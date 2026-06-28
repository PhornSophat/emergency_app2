import 'package:flutter/material.dart';
import '../data/repositories.dart';
import '../models/emergency_contact.dart';

class ContactsProvider with ChangeNotifier {
  final ContactRepositoryImpl _repo = ContactRepositoryImpl(
    apiBaseUrl: 'http://10.0.2.2:3000/api/v1',
    cache: InMemoryContactCache(),
  );

  List<EmergencyContact> _contacts = [];
  bool _isLoading = false;
  String? _error;

  List<EmergencyContact> get contacts => _contacts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadContacts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _contacts = await _repo.fetchGlobalContacts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
