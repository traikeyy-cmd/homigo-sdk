import 'package:flutter/material.dart';

/// إعدادات الهوية البصرية الخاصة بكل تطبيق يستخدم HomiGo SDK.
@immutable
class HomiGoBrand {
  final Color primaryColor;
  final Color secondaryColor;

  final double borderRadius;

  final bool useGlassEffect;
  final double glassBlur;
  final double glassOpacity;

  final String? fontFamily;

  const HomiGoBrand({
    required this.primaryColor,
    required this.secondaryColor,
    this.borderRadius = 18,
    this.useGlassEffect = true,
    this.glassBlur = 18,
    this.glassOpacity = 0.72,
    this.fontFamily,
  });

  HomiGoBrand copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    double? borderRadius,
    bool? useGlassEffect,
    double? glassBlur,
    double? glassOpacity,
    String? fontFamily,
  }) {
    return HomiGoBrand(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      borderRadius: borderRadius ?? this.borderRadius,
      useGlassEffect: useGlassEffect ?? this.useGlassEffect,
      glassBlur: glassBlur ?? this.glassBlur,
      glassOpacity: glassOpacity ?? this.glassOpacity,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}
