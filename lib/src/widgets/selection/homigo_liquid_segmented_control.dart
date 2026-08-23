import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/liquid/homigo_liquid_surface.dart';
import '../../design_system/tokens/homigo_typography.dart';

/// عنصر واحد داخل HomiGoLiquidSegmentedControl.
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

/// اختيار مائي موحد للتبويبات والخيارات.
///
/// أمثلة الاستخدام:
/// System / Light / Dark
/// يومي / أسبوعي / شهري
/// الكل / نشط / مكتمل
class HomiGoLiquidSegmentedControl<T> extends StatelessWidget {
  final List<HomiGoSegmentItem<T>> items;
  final T value;
  final ValueChanged<T> onChanged;

  final double height;
  final double? borderRadius;

  final Color? tintColor;

  final EdgeInsetsGeometry margin;

  const HomiGoLiquidSegmentedControl({
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

    return Container(
      margin: margin,
      child: HomiGoLiquidSurface(
        height: height,
        borderRadius: radius,
        tintColor: effectiveTint,
        tintStrength: 0.018,
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            for (final item in items)
              Expanded(
                child: _HomiGoLiquidSegment<T>(
                  item: item,
                  selected: item.value == value,
                  onTap: () {
                    if (item.value != value) {
                      onChanged(item.value);
                    }
                  },
                  tintColor: effectiveTint,
                  radius: radius - 4,
                  brightness: theme.brightness,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HomiGoLiquidSegment<T> extends StatefulWidget {
  final HomiGoSegmentItem<T> item;
  final bool selected;
  final VoidCallback onTap;

  final Color tintColor;
  final double radius;
  final Brightness brightness;

  const _HomiGoLiquidSegment({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.tintColor,
    required this.radius,
    required this.brightness,
  });

  @override
  State<_HomiGoLiquidSegment<T>> createState() =>
      _HomiGoLiquidSegmentState<T>();
}

class _HomiGoLiquidSegmentState<T> extends State<_HomiGoLiquidSegment<T>> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selected = widget.selected;

    final selectedColor = widget.tintColor;

    final normalColor =
        theme.textTheme.bodyMedium?.color ??
        (widget.brightness == Brightness.dark ? Colors.white : Colors.black87);

    final foregroundColor = selected ? selectedColor : normalColor;

    Widget content = Center(
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
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
                duration: const Duration(milliseconds: 180),
                scale: selected ? 1.06 : 1.0,
                child: Icon(widget.item.icon, size: 19, color: foregroundColor),
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
    );

    if (selected) {
      content = HomiGoLiquidSurface(
        borderRadius: widget.radius,
        tintColor: widget.tintColor,
        tintStrength: _pressed ? 0.15 : 0.105,
        selected: true,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: content,
      );
    } else {
      content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: content,
      );
    }

    return AnimatedScale(
      scale: _pressed ? 0.975 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.radius),
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (pressed) {
            setState(() {
              _pressed = pressed;
            });
          },
          borderRadius: BorderRadius.circular(widget.radius),
          splashColor: widget.tintColor.withValues(alpha: 0.025),
          highlightColor: Colors.transparent,
          child: content,
        ),
      ),
    );
  }
}
