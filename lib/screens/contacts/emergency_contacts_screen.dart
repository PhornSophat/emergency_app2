import 'package:flutter/material.dart';
import '../../models/emergency_contact.dart';
import 'contact_list_screen.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  ContactCategory _selected = ContactCategory.family;
  final _searchController = TextEditingController();
  String _query = '';

  static const _kRed = Color(0xFFDC2626);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = ContactCategory.values.where((c) {
      return c.label.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            'Emergency contacts',
            style: TextStyle(
              color: Color(0xFFDC2626),
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
        ),
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
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final cat = filtered[i];
              final isSelected = cat == _selected;
              return _CategoryTile(
                category: cat,
                isSelected: isSelected,
                onTap: () {
                  setState(() => _selected = cat);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ContactListScreen(category: cat),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final ContactCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  static const _kRed = Color(0xFFDC2626);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${category.label} emergency contacts',
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? _kRed : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected ? _kRed : const Color(0xFFE0E0E0),
              width: 1.4,
            ),
          ),
          child: Row(
            children: [
              Text(category.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              Icon(
                Icons.phone,
                color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}