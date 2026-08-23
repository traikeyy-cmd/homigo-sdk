import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/tokens/homigo_colors.dart';

/// بطاقة زجاجية موحدة ضمن HomiGo SDK.
///
/// تعتمد تلقائيًا على:
/// - Light / Dark mode
/// - إعدادات HomiGoBrand
/// - Glass blur
/// - Glass opacity
/// - Border radius
class HomiGoGlassCard extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final double? width;
  final double? height;

  final double? borderRadius;
  final double? blur;
  final double? opacity;

  final Color? backgroundColor;
  final Color? borderColor;

  final VoidCallback? onTap;

  final bool enabled;

  const HomiGoGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.blur,
    this.opacity,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final effectiveRadius = borderRadius ?? brand.borderRadius;
    final effectiveBlur = blur ?? brand.glassBlur;

    final effectiveOpacity = (opacity ?? brand.glassOpacity)
        .clamp(0.0, 1.0)
        .toDouble();

    final glassEnabled = enabled && brand.useGlassEffect;

    final effectiveBackgroundColor =
        backgroundColor ??
        (glassEnabled
            ? (isDark ? HomiGoColors.glassDark : HomiGoColors.glassLight)
                  .withValues(alpha: effectiveOpacity)
            : theme.colorScheme.surface);

    final effectiveBorderColor =
        borderColor ??
        (isDark ? HomiGoColors.glassBorderDark : HomiGoColors.glassBorderLight);

    final radius = BorderRadius.circular(effectiveRadius);

    Widget content = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: radius,
        border: Border.all(color: effectiveBorderColor, width: 1),
      ),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, borderRadius: radius, child: content),
      );
    }

    if (glassEnabled) {
      content = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: effectiveBlur,
            sigmaY: effectiveBlur,
          ),
          child: content,
        ),
      );
    }

    return Container(margin: margin, child: content);
  }
}
