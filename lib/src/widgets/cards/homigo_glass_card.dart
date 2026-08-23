import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/liquid/homigo_liquid_surface.dart';

/// بطاقة زجاجية مائية موحدة ضمن HomiGo SDK.
///
/// تعتمد على HomiGo Liquid Surface بدل الحدود التقليدية.
/// الحواف تظهر كتشكيل/حفر ضوئي داخل السطح وليس Border مرسوم.
class HomiGoGlassCard extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final double? width;
  final double? height;

  final double? borderRadius;
  final double? blur;
  final double? opacity;

  /// يحتفظ به للتوافق مع الإصدارات السابقة.
  ///
  /// في نظام Liquid الجديد يستخدم كلون Tint وليس كخلفية مصمتة.
  final Color? backgroundColor;

  /// محتفظ به للتوافق مع الإصدارات السابقة.
  ///
  /// لا يتم رسم Border تقليدي في نظام Liquid.
  final Color? borderColor;

  final VoidCallback? onTap;

  final bool enabled;

  /// إذا كانت البطاقة في حالة اختيار أو تركيز.
  final bool selected;

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
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;

    final effectiveRadius = borderRadius ?? brand.borderRadius;

    final effectiveOpacity = (opacity ?? brand.glassOpacity)
        .clamp(0.0, 1.0)
        .toDouble();

    // نحول قيمة Glass Opacity القديمة إلى Tint مائي خفيف.
    // لا نستخدمها كخلفية مصمتة.
    final tintStrength = 0.035 + (effectiveOpacity * 0.075);

    final radius = BorderRadius.circular(effectiveRadius);

    Widget content = HomiGoLiquidSurface(
      width: width,
      height: height,
      borderRadius: effectiveRadius,
      blur: blur,
      tintColor: backgroundColor,
      tintStrength: tintStrength,
      selected: selected,
      enabled: enabled && brand.useGlassEffect,
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: brand.primaryColor.withValues(alpha: 0.06),
          highlightColor: Colors.white.withValues(alpha: 0.04),
          child: content,
        ),
      );
    }

    return Container(margin: margin, child: content);
  }
}
