import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/emergency_contact.dart';
import '../../providers/app_preferences_provider.dart';
import 'contact_list_screen.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
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
    final prefs = context.watch<AppPreferencesProvider>();
    final isKhmer = prefs.isKhmerSelected;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filtered = ContactCategory.values.where((c) {
      return c.labelFor(isKhmer).toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
          child: Text(
            prefs.translate('Emergency contacts', 'ទំនាក់ទំនងបន្ទាន់'),
            style: const TextStyle(
              color: _kRed,
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
              hintText: prefs.translate('Search', 'ស្វែងរក'),
              hintStyle: TextStyle(
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF94A3B8),
              ),
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
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            itemCount: filtered.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final cat = filtered[i];
              return _CategoryTile(
                category: cat,
                label: cat.labelFor(isKhmer),
                onTap: () {
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

class _CategoryTile extends StatefulWidget {
  const _CategoryTile({
    required this.category,
    required this.label,
    required this.onTap,
  });

  final ContactCategory category;
  final String label;
  final VoidCallback onTap;

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _isPressed = false;

  static const _kRed = Color(0xFFDC2626);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: '${widget.label} emergency contacts',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: _isPressed
                ? _kRed
                : (isDark ? const Color(0xFF1E293B) : Colors.white),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: _isPressed
                  ? _kRed
                  : (isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE0E0E0)),
              width: 1.4,
            ),
            boxShadow: _isPressed
                ? [
                    BoxShadow(
                      color: _kRed.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isPressed
                      ? Colors.white.withValues(alpha: 0.18)
                      : widget.category.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.category.icon,
                  color: _isPressed ? Colors.white : widget.category.color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _isPressed
                        ? Colors.white
                        : (isDark
                              ? const Color(0xFFF8FAFC)
                              : const Color(0xFF1A1A1A)),
                  ),
                ),
              ),
              Icon(
                Icons.phone,
                color: _isPressed
                    ? Colors.white
                    : (isDark
                          ? const Color(0xFFF8FAFC)
                          : const Color(0xFF1A1A1A)),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
