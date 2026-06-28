import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/emergency_contact.dart';
import '../../data/contacts_data.dart';
import '../../providers/app_preferences_provider.dart';
import 'add_contact_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key, required this.category});

  final ContactCategory category;

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  static const _kRed = Color(0xFFDC2626);

  List<EmergencyContact> get _contacts {
    final isKhmer = context.read<AppPreferencesProvider>().isKhmerSelected;
    final all = kEmergencyContacts
        .where((c) => c.category == widget.category)
        .toList();
    if (_query.isEmpty) return all;
    return all
        .where(
          (c) =>
              c
                  .displayNameFor(isKhmer)
                  .toLowerCase()
                  .contains(_query.toLowerCase()) ||
              c.category
                  .labelFor(isKhmer)
                  .toLowerCase()
                  .contains(_query.toLowerCase()) ||
              c.phone.contains(_query),
        )
        .toList();
  }

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.read<AppPreferencesProvider>().translate(
                'Could not call $phone',
                'មិនអាចហៅទៅលេខ $phone បានទេ',
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contacts = _contacts;
    final isFamily = widget.category == ContactCategory.family;
    final prefs = context.watch<AppPreferencesProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categoryLabel = widget.category.labelFor(prefs.isKhmerSelected);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: const BackButton(color: _kRed),
        title: Text(
          prefs.translate('Emergency contacts', 'ទំនាក់ទំនងបន្ទាន់'),
          style: const TextStyle(
            color: _kRed,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: prefs.translate('Search', 'ស្វែងរក'),
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFB0B0B0)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                filled: true,
                fillColor: theme.cardColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFF334155) : _kRed,
                    width: 1.4,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: const BorderSide(color: _kRed, width: 2),
                ),
              ),
            ),
          ),

          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: widget.category.color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.category.icon,
                    color: widget.category.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  categoryLabel,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),

          // Contact list
          Expanded(
            child: contacts.isEmpty
                ? Center(
                    child: Text(
                      prefs.translate(
                        'No contacts found.',
                        'រកមិនឃើញទំនាក់ទំនងទេ។',
                      ),
                      style: const TextStyle(color: Color(0xFF9E9E9E)),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: contacts.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final c = contacts[i];
                      return _ContactCard(
                        contact: c,
                        showAvatar: isFamily,
                        isKhmerSelected: prefs.isKhmerSelected,
                        onCall: () => _call(c.phone),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddContactScreen(category: widget.category),
            ),
          );
        },
        backgroundColor: _kRed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.contact,
    required this.showAvatar,
    required this.isKhmerSelected,
    required this.onCall,
  });

  final EmergencyContact contact;
  final bool showAvatar;
  final bool isKhmerSelected;
  final VoidCallback onCall;

  static const _kRed = Color(0xFFDC2626);

  // Deterministic color per name initial
  Color _avatarColor(String name) {
    const colors = [
      Color(0xFF1E88E5),
      Color(0xFF43A047),
      Color(0xFFE53935),
      Color(0xFF8E24AA),
      Color(0xFF00897B),
      Color(0xFFF4511E),
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final displayName = contact.displayNameFor(isKhmerSelected);
    final displayAddress = contact.displayAddressFor(isKhmerSelected);

    return Semantics(
      label: '$displayName, ${contact.phone}.',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE0E0E0),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image or Avatar section
              if (contact.imageUrl != null && showAvatar == false)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Container(
                    color: const Color(0xFFF5F5F5),
                    height: 160,
                    width: double.infinity,
                    child: Image.network(
                      contact.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: contact.category.color.withValues(alpha: 0.1),
                          child: Center(
                            child: Icon(
                              contact.category.icon,
                              color: contact.category.color,
                              size: 44,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              // Content section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar for family/friends
                    if (showAvatar)
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: _avatarColor(displayName),
                        child: Text(
                          displayName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    if (showAvatar) const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: isDark
                                  ? const Color(0xFFF8FAFC)
                                  : const Color(0xFF1A1A1A),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (displayAddress != null)
                            Text(
                              displayAddress,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 14, color: _kRed),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  contact.phone,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? const Color(0xFFF8FAFC)
                                        : const Color(0xFF1A1A1A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Semantics(
                      button: true,
                      label: isKhmerSelected
                          ? 'ហៅទៅ $displayName'
                          : 'Call $displayName',
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: onCall,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _kRed.withValues(alpha: 0.1),
                              border: Border.all(
                                color: _kRed.withValues(alpha: 0.3),
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.phone,
                              color: _kRed,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
