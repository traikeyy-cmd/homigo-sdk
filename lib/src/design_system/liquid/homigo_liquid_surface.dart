import 'package:flutter/material.dart';

import '../native/homigo_native_surface.dart';

/// Compatibility surface for applications using the old HomiGo API.
///
/// الاسم والـAPI محفوظان للتوافق، لكن التنفيذ الداخلي أصبح
/// HomiGo Native UI بدون BackdropFilter أو ImageFilter.blur.
///
/// [blur] محفوظ فقط لعدم كسر التطبيقات القديمة، ولا يتم استخدامه.
class HomiGoLiquidSurface extends StatelessWidget {
  final Widget child;

  final Color? tintColor;

  final double? borderRadius;

  /// محفوظ للتوافق فقط، ولا يتم تطبيق Blur.
  final double? blur;

  final double tintStrength;

  final EdgeInsetsGeometry? padding;

  final double? width;
  final double? height;

  final bool selected;
  final bool enabled;

  const HomiGoLiquidSurface({
    super.key,
    required this.child,
    this.tintColor,
    this.borderRadius,
    this.blur,
    this.tintStrength = 0.10,
    this.padding,
    this.width,
    this.height,
    this.selected = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return HomiGoNativeSurface(
      width: width,
      height: height,
      borderRadius: borderRadius,
      tintColor: tintColor,
      tintStrength: tintStrength,
      selected: selected,
      enabled: enabled,
      padding: padding,
      child: child,
    );
  }
}
