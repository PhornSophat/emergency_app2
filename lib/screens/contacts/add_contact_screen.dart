import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/emergency_contact.dart';
import '../../providers/app_preferences_provider.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key, required this.category});

  final ContactCategory category;

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _relationshipController = TextEditingController();
  bool _isLoading = false;

  static const _kRed = Color(0xFFDC2626);

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  Future<void> _addContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() => _isLoading = false);

      // Return the new contact data to parent
      Navigator.pop(context, {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'relationship': _relationshipController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Provider.of<AppPreferencesProvider>(
                context,
                listen: false,
              ).translate(
                'Contact added successfully!',
                'បានបន្ថែមទំនាក់ទំនងដោយជោគជ័យ!',
              ),
            ),
            backgroundColor: _kRed,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<AppPreferencesProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: const BackButton(color: _kRed),
        title: Text(
          prefs.translate('Add Emergency contact', 'បន្ថែមទំនាក់ទំនងបន្ទាន់'),
          style: const TextStyle(
            color: _kRed,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full Name
              _buildLabel(prefs.translate('Full Name', 'ឈ្មោះពេញ'), isDark),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _nameController,
                hintText: prefs.translate('Enter Full Name', 'បញ្ចូលឈ្មោះពេញ'),
                isDark: isDark,
                validator: (v) {
                  if (v?.isEmpty ?? true) {
                    return prefs.translate('Name is required', 'ត្រូវការឈ្មោះ');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Phone Number
              _buildLabel(
                prefs.translate('Phone Number', 'លេខទូរស័ព្ទ'),
                isDark,
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _phoneController,
                hintText: prefs.translate(
                  'Enter Phone number',
                  'បញ្ចូលលេខទូរស័ព្ទ',
                ),
                keyboardType: TextInputType.phone,
                isDark: isDark,
                validator: (v) {
                  if (v?.isEmpty ?? true) {
                    return prefs.translate(
                      'Phone number is required',
                      'ត្រូវការលេខទូរស័ព្ទ',
                    );
                  }
                  if (v!.length < 7) {
                    return prefs.translate(
                      'Enter a valid phone number',
                      'បញ្ចូលលេខទូរស័ព្ទត្រឹមត្រូវ',
                    );
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Email
              _buildLabel(prefs.translate('Email', 'អ៊ីមែល'), isDark),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hintText: 'example@gmail.com',
                keyboardType: TextInputType.emailAddress,
                isDark: isDark,
                validator: (v) {
                  if (v?.isEmpty ?? true) return null;
                  if (!v!.contains('@')) {
                    return prefs.translate(
                      'Enter a valid email',
                      'បញ្ចូលអ៊ីមែលត្រឹមត្រូវ',
                    );
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Relationship
              _buildLabel(
                prefs.translate('Relationship', 'ទំនាក់ទំនង'),
                isDark,
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _relationshipController,
                hintText: prefs.translate('eg Sister', 'ឧ. បងស្រី'),
                isDark: isDark,
                validator: (v) {
                  if (v?.isEmpty ?? true) {
                    return prefs.translate(
                      'Relationship is required',
                      'ត្រូវការទំនាក់ទំនង',
                    );
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Add Contact Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addContact,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kRed,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    disabledBackgroundColor: _kRed.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          prefs.translate('Add contact', 'បន្ថែមទំនាក់ទំនង'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF111111),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF111111)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF8A8A8A) : const Color(0xFFB0B0B0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF171717) : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF2A2A2A) : _kRed,
            width: 1.4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }
}
