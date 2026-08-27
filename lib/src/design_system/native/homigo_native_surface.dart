import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../tokens/homigo_colors.dart';
import '../tokens/homigo_elevation.dart';
import '../tokens/homigo_motion.dart';

/// السطح الأساسي الحديث في HomiGo SDK.
///
/// خفيف وسريع:
/// - بدون BackdropFilter
/// - بدون ImageFilter.blur
/// - بدون Glass / Liquid effects
/// - خلفية Solid
/// - Border خفيف
/// - Shadow بسيط
///
/// يدعم [tintColor] و [tintStrength] كـ Solid color blend
/// للمحافظة على مرونة المكونات القديمة أثناء الانتقال إلى Native UI.
class HomiGoNativeSurface extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry? padding;

  final double? width;
  final double? height;

  final double? borderRadius;

  final Color? backgroundColor;
  final Color? borderColor;

  /// لون Accent اختياري.
  ///
  /// لا يستخدم Glass أو Blur.
  /// يتم دمجه مباشرة مع لون السطح.
  final Color? tintColor;

  /// قوة الـSolid tint من 0 إلى 1.
  final double tintStrength;

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
    this.tintColor,
    this.tintStrength = 0.0,
    this.selected = false,
    this.enabled = true,
    this.elevated = true,
  }) : assert(tintStrength >= 0 && tintStrength <= 1);

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

    final tint = tintColor ?? brand.primaryColor;

    final requestedTint = (selected ? tintStrength * 1.35 : tintStrength)
        .clamp(0.0, 1.0)
        .toDouble();

    // يحافظ على سلوك selected الحالي حتى عند عدم تمرير tintStrength.
    final selectedFloor = selected ? (isDark ? 0.14 : 0.06) : 0.0;

    final effectiveTintStrength = requestedTint < selectedFloor
        ? selectedFloor
        : requestedTint;

    final effectiveBackground = effectiveTintStrength > 0
        ? Color.alphaBlend(
            tint.withValues(alpha: effectiveTintStrength),
            baseSurface,
          )
        : baseSurface;

    final effectiveBorder = selected
        ? tint.withValues(alpha: isDark ? 0.34 : 0.18)
        : baseBorder;

    return AnimatedOpacity(
      duration: HomiGoMotion.fast,
      curve: HomiGoMotion.fastCurve,
      opacity: enabled ? 1.0 : 0.52,
      child: AnimatedContainer(
        duration: HomiGoMotion.standard,
        curve: HomiGoMotion.standardCurve,
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
                      alpha: isDark
                          ? HomiGoElevation.cardOpacityDark
                          : HomiGoElevation.cardOpacityLight,
                    ),
                    blurRadius: HomiGoElevation.cardBlur,
                    offset: HomiGoElevation.cardOffset,
                  ),
                ]
              : const [],
        ),
        child: child,
      ),
    );
  }
}
