import 'package:flutter/material.dart';

class AppPreferencesPanel extends StatelessWidget {
  final bool isKhmerSelected;
  final bool isDarkMode;
  final bool isLocationSharing;
  final ValueChanged<bool> onLanguageChanged;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<bool> onLocationChanged;

  const AppPreferencesPanel({
    super.key,
    required this.isKhmerSelected,
    required this.isDarkMode,
    required this.isLocationSharing,
    required this.onLanguageChanged,
    required this.onDarkModeChanged,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9), 
          width: 1.2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // 1. LANGUAGE SELECTOR TILE
          _buildSettingsTile(
            context: context,
            icon: Icons.language,
            iconColor: Colors.blue,
            title: 'App Language',
            subtitle: isKhmerSelected ? 'ភាសាខ្មែរ (Khmer)' : 'English (EN)',
            trailing: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LanguageOptionButton(
                    label: 'EN', 
                    isSelected: !isKhmerSelected, 
                    onTap: () => onLanguageChanged(false),
                  ),
                  _LanguageOptionButton(
                    label: 'KH', 
                    isSelected: isKhmerSelected, 
                    onTap: () => onLanguageChanged(true),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),

          // 2. DARK THEME TOGGLE TILE
          _buildSettingsTile(
            context: context,
            icon: Icons.dark_mode,
            iconColor: Colors.purple,
            title: 'Dark Theme',
            subtitle: 'Optimized dark tech visualization',
            trailing: Switch(
              value: isDarkMode,
              activeColor: const Color(0xFFEF4444),
              activeTrackColor: const Color(0xFFEF4444).withOpacity(0.4),
              inactiveThumbColor: const Color(0xFF64748B),
              onChanged: onDarkModeChanged,
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),

          // 3. GPS LOCATION SWITCH TILE
          _buildSettingsTile(
            context: context,
            icon: Icons.location_on,
            iconColor: Colors.green,
            title: 'GPS Location Sharing',
            subtitle: 'Share location layout with local 119 dispatch',
            trailing: Switch(
              value: isLocationSharing,
              activeColor: const Color(0xFFEF4444),
              activeTrackColor: const Color(0xFFEF4444).withOpacity(0.4),
              inactiveThumbColor: const Color(0xFF64748B),
              onChanged: onLocationChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(isDark ? 0.2 : 0.1), 
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.w700, 
                    color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle, 
                  style: TextStyle(
                    fontSize: 11, 
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _LanguageOptionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOptionButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? (isDark ? const Color(0xFF1E293B) : Colors.white) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected && !isDark
              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected 
                ? const Color(0xFFEF4444) 
                : (isDark ? const Color(0xFF64748B) : const Color(0xFF475569)),
          ),
        ),
      ),
    );
  }
}