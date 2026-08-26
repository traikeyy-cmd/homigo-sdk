import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../tokens/homigo_colors.dart';

/// السطح الأساسي الحديث في HomiGo SDK.
///
/// مصمم ليكون خفيفًا وسريعًا:
/// - بدون BackdropFilter
/// - بدون ImageFilter.blur
/// - بدون Glass / Liquid effects
/// - خلفية Solid
/// - Border خفيف
/// - Shadow بسيط
///
/// سيكون الأساس الجديد للبطاقات والأزرار وعناصر الاختيار
/// وبقية مكونات HomiGo Native UI.
class HomiGoNativeSurface extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry? padding;

  final double? width;
  final double? height;

  final double? borderRadius;

  final Color? backgroundColor;
  final Color? borderColor;

  /// إذا كان العنصر محددًا أو نشطًا.
  final bool selected;

  /// إذا كان العنصر مفعّلًا.
  final bool enabled;

  /// إظهار ارتفاع بصري خفيف عن الخلفية.
  final bool elevated;

  const HomiGoNativeSurface({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.selected = false,
    this.enabled = true,
    this.elevated = true,
  });

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final radius = borderRadius ?? brand.borderRadius;

    final baseSurface =
        backgroundColor ??
        (isDark ? HomiGoColors.darkSurface : HomiGoColors.lightSurface);

    final baseBorder =
        borderColor ??
        (isDark ? HomiGoColors.darkBorder : HomiGoColors.lightBorder);

    final effectiveBackground = selected
        ? Color.alphaBlend(
            brand.primaryColor.withValues(alpha: isDark ? 0.14 : 0.06),
            baseSurface,
          )
        : baseSurface;

    final effectiveBorder = selected
        ? brand.primaryColor.withValues(alpha: isDark ? 0.34 : 0.18)
        : baseBorder;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      opacity: enabled ? 1.0 : 0.52,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: effectiveBackground,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: effectiveBorder, width: 1),
          boxShadow: elevated
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.22 : 0.055,
                    ),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : const [],
        ),
        child: child,
      ),
    );
  }
}
