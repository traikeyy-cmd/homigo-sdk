import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/native/homigo_native_surface.dart';
import '../../design_system/tokens/homigo_colors.dart';
import '../../design_system/tokens/homigo_elevation.dart';
import '../../design_system/tokens/homigo_motion.dart';
import '../../design_system/tokens/homigo_typography.dart';

@immutable
class HomiGoSegmentItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const HomiGoSegmentItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

/// الـSegmented Control الرسمي في HomiGo Design System.
///
/// مكوّن عام لأي تطبيق:
/// - فلاتر
/// - حالات
/// - طرق عرض
/// - تبويبات قصيرة
///
/// لا يعتمد على Liquid أو Glass.
class HomiGoSegmentedControl<T> extends StatelessWidget {
  final List<HomiGoSegmentItem<T>> items;
  final T value;
  final ValueChanged<T> onChanged;

  final double height;
  final double? borderRadius;

  final Color? tintColor;

  final EdgeInsetsGeometry margin;

  const HomiGoSegmentedControl({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.height = 54,
    this.borderRadius,
    this.tintColor,
    this.margin = EdgeInsets.zero,
  }) : assert(items.length > 1);

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    final radius = borderRadius ?? brand.borderRadius;
    final effectiveTint = tintColor ?? brand.primaryColor;

    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? HomiGoColors.darkSurfaceVariant
        : HomiGoColors.lightSurfaceVariant;

    final borderColor = isDark
        ? HomiGoColors.darkBorder
        : HomiGoColors.lightBorder;

    final segmentRadius = radius > 4 ? radius - 4 : 0.0;

    return Container(
      margin: margin,
      child: HomiGoNativeSurface(
        height: height,
        borderRadius: radius,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        elevated: false,
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            for (final item in items)
              Expanded(
                child: _HomiGoSegment<T>(
                  item: item,
                  selected: item.value == value,
                  onTap: () {
                    if (item.value != value) {
                      onChanged(item.value);
                    }
                  },
                  tintColor: effectiveTint,
                  radius: segmentRadius,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HomiGoSegment<T> extends StatefulWidget {
  final HomiGoSegmentItem<T> item;
  final bool selected;
  final VoidCallback onTap;
  final Color tintColor;
  final double radius;

  const _HomiGoSegment({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.tintColor,
    required this.radius,
  });

  @override
  State<_HomiGoSegment<T>> createState() => _HomiGoSegmentState<T>();
}

class _HomiGoSegmentState<T> extends State<_HomiGoSegment<T>> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value || !mounted) {
      return;
    }

    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selected = widget.selected;

    final inactiveColor = theme.brightness == Brightness.dark
        ? HomiGoColors.darkTextSecondary
        : HomiGoColors.lightTextSecondary;

    final foregroundColor = selected ? Colors.white : inactiveColor;

    return AnimatedScale(
      scale: _pressed ? HomiGoMotion.compactPressedScale : 1.0,
      duration: HomiGoMotion.press,
      curve: HomiGoMotion.fastCurve,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.radius),
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: _setPressed,
          borderRadius: BorderRadius.circular(widget.radius),
          splashColor: widget.tintColor.withValues(alpha: 0.06),
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: HomiGoMotion.standard,
            curve: HomiGoMotion.standardCurve,
            decoration: BoxDecoration(
              color: selected ? widget.tintColor : Colors.transparent,
              borderRadius: BorderRadius.circular(widget.radius),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: widget.tintColor.withValues(
                          alpha: HomiGoElevation.selectedOpacity,
                        ),
                        blurRadius: HomiGoElevation.selectedBlur,
                        offset: HomiGoElevation.selectedOffset,
                      ),
                    ]
                  : const [],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: HomiGoMotion.standard,
                curve: HomiGoMotion.standardCurve,
                style: HomiGoTypography.labelMedium.copyWith(
                  color: foregroundColor,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.item.icon != null) ...[
                      AnimatedScale(
                        duration: HomiGoMotion.standard,
                        curve: HomiGoMotion.standardCurve,
                        scale: selected ? 1.06 : 1.0,
                        child: Icon(
                          widget.item.icon,
                          size: 18,
                          color: foregroundColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: Text(
                        widget.item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
