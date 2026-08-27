import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/theme/homigo_dynamic_colors.dart';
import '../../design_system/tokens/homigo_colors.dart';
import '../../design_system/tokens/homigo_motion.dart';
import '../../design_system/tokens/homigo_radius.dart';
import '../../platform/system_ui/homigo_insets.dart';
import '../cards/homigo_glass_card.dart';

@immutable
class HomiGoNavigationItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const HomiGoNavigationItem({
    required this.icon,
    required this.label,
    this.activeIcon,
  });
}

/// شريط التنقل السفلي في HomiGo Native UI.
///
/// يحافظ على نفس API السابق لكن بدون Liquid / Glass داخل العناصر.
class HomiGoNavigationBar extends StatelessWidget {
  final List<HomiGoNavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  final EdgeInsetsGeometry margin;

  final bool respectBottomInset;

  const HomiGoNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.margin = const EdgeInsets.fromLTRB(12, 0, 12, 12),
    this.respectBottomInset = true,
  }) : assert(items.length >= 2),
       assert(selectedIndex >= 0),
       assert(selectedIndex < items.length);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = HomiGoDynamicColors.primary(context);

    final isDark = theme.brightness == Brightness.dark;

    final inactiveColor = isDark
        ? HomiGoColors.darkTextSecondary
        : HomiGoColors.lightTextSecondary;

    Widget bar = HomiGoGlassCard(
      margin: margin,
      borderRadius: HomiGoRadius.xl,
      padding: const EdgeInsets.all(6),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final selected = index == selectedIndex;

          return Expanded(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () => onDestinationSelected(index),
                borderRadius: BorderRadius.circular(16),
                splashColor: primary.withValues(alpha: 0.06),
                highlightColor: Colors.transparent,
                child: AnimatedContainer(
                  duration: HomiGoMotion.standard,
                  curve: HomiGoMotion.standardCurve,
                  padding: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? primary.withValues(alpha: isDark ? 0.18 : 0.09)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedScale(
                        scale: selected ? 1.06 : 1.0,
                        duration: HomiGoMotion.standard,
                        curve: HomiGoMotion.standardCurve,
                        child: Icon(
                          selected ? item.activeIcon ?? item.icon : item.icon,
                          size: 22,
                          color: selected ? primary : inactiveColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: HomiGoMotion.standard,
                        curve: HomiGoMotion.standardCurve,
                        style:
                            theme.textTheme.labelMedium?.copyWith(
                              color: selected ? primary : inactiveColor,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ) ??
                            TextStyle(
                              color: selected ? primary : inactiveColor,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );

    if (respectBottomInset) {
      bar = HomiGoSafeArea(
        top: false,
        left: false,
        right: false,
        maintainBottomViewPadding: true,
        child: bar,
      );
    }

    return bar;
  }
}
