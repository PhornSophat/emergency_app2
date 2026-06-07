import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/emergency_contact.dart';
import '../../data/contacts_data.dart';

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
    final all = kEmergencyContacts
        .where((c) => c.category == widget.category)
        .toList();
    if (_query.isEmpty) return all;
    return all
        .where((c) =>
            c.name.toLowerCase().contains(_query.toLowerCase()) ||
            c.phone.contains(_query))
        .toList();
  }

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not call $phone')),
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: _kRed),
        title: const Text(
          'Emergency contacts',
          style: TextStyle(
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
                hintText: 'Search',
                hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFB0B0B0)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: const BorderSide(color: _kRed, width: 1.4),
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
                Text(
                  widget.category.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.category.label,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),

          // Contact list
          Expanded(
            child: contacts.isEmpty
                ? const Center(
                    child: Text(
                      'No contacts found.',
                      style: TextStyle(color: Color(0xFF9E9E9E)),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: contacts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final c = contacts[i];
                      return _ContactCard(
                        contact: c,
                        showAvatar: isFamily,
                        onCall: () => _call(c.phone),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
    required this.onCall,
  });

  final EmergencyContact contact;
  final bool showAvatar;
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
    return Semantics(
      label: '${contact.name}, ${contact.phone}. Tap phone button to call.',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1.4),
        ),
        child: Row(
          children: [
            if (showAvatar) ...[
              CircleAvatar(
                radius: 22,
                backgroundColor: _avatarColor(contact.name),
                child: Text(
                  contact.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showAvatar)
                    Text(
                      contact.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  Text(
                    contact.phone,
                    style: TextStyle(
                      fontSize: showAvatar ? 13 : 15,
                      color: showAvatar
                          ? const Color(0xFF757575)
                          : const Color(0xFF1A1A1A),
                      fontWeight:
                          showAvatar ? FontWeight.w400 : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Semantics(
              button: true,
              label: 'Call ${contact.name}',
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: onCall,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE0E0E0), width: 1.4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Icon(Icons.phone, color: _kRed, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}