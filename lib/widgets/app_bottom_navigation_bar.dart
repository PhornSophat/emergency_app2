import 'package:flutter/material.dart';

class AppBottomNavigationItem {
  const AppBottomNavigationItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  }) : assert(items.length > 1, 'Use at least two navigation items.');

  final int currentIndex;
  final List<AppBottomNavigationItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 380;
          final horizontalMargin = isCompact ? 14.0 : 22.0;
          final verticalMargin = isCompact ? 10.0 : 14.0;

          return Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalMargin,
              0,
              horizontalMargin,
              verticalMargin,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isCompact ? 8 : 12, vertical: 8),
                    child: Row(
                      children: List.generate(items.length, (index) {
                        final item = items[index];
                        final isSelected = index == currentIndex;

                        return Expanded(
                          child: _NavigationButton(
                            item: item,
                            isSelected: isSelected,
                            compact: isCompact,
                            onTap: () => onTap(index),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.item,
    required this.isSelected,
    required this.compact,
    required this.onTap,
  });

  final AppBottomNavigationItem item;
  final bool isSelected;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 240),
                scale: isSelected ? 1.08 : 1.0,
                curve: Curves.easeOutBack,
                child: Icon(
                  item.icon,
                  size: compact ? 22 : 24,
                  color: isSelected ? Colors.white : const Color(0xFFFFB3B3),
                ),
              ),
              SizedBox(height: compact ? 3 : 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: compact ? 9 : 10,
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                child: Text(item.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
