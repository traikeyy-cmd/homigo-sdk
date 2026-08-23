import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/liquid/homigo_liquid_surface.dart';
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
  }) : assert(items.length >= 2);

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    Widget bar = HomiGoGlassCard(
      margin: margin,
      borderRadius: 24,
      padding: const EdgeInsets.all(6),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final selected = index == selectedIndex;

          final color = selected
              ? brand.primaryColor
              : theme.textTheme.bodySmall?.color;

          return Expanded(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: () => onDestinationSelected(index),
                borderRadius: BorderRadius.circular(18),
                child: HomiGoLiquidSurface(
                  borderRadius: 18,
                  tintColor: brand.primaryColor,
                  selected: selected,
                  tintStrength: selected ? 0.09 : 0.0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 4,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selected ? item.activeIcon ?? item.icon : item.icon,
                        size: 22,
                        color: color,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: color,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
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
