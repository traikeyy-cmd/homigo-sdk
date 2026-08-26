import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';

/// أيقونة بارزة بهوية HomiGo Native UI.
///
/// تستخدم فوق البطاقات لإعطاء إحساس أن الأيقونة
/// عنصر مستقل ومرتفع عن سطح البطاقة.
///
/// لا تستخدم Blur أو BackdropFilter.
class HomiGoElevatedIcon extends StatelessWidget {
  final IconData icon;

  /// اللون الأساسي للأيقونة.
  final Color? color;

  /// اللون الثاني للـGradient.
  ///
  /// إذا لم يتم تمريره يتم اشتقاق درجة أفتح من [color].
  final Color? secondaryColor;

  final double size;
  final double iconSize;
  final double borderRadius;

  final bool elevated;
  final bool enabled;

  const HomiGoElevatedIcon({
    super.key,
    required this.icon,
    this.color,
    this.secondaryColor,
    this.size = 52,
    this.iconSize = 25,
    this.borderRadius = 16,
    this.elevated = true,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;

    final baseColor = color ?? brand.primaryColor;

    final gradientEnd =
        secondaryColor ?? Color.lerp(baseColor, Colors.white, 0.22)!;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      opacity: enabled ? 1.0 : 0.48,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientEnd, baseColor],
          ),
          boxShadow: elevated
              ? [
                  BoxShadow(
                    color: baseColor.withValues(alpha: 0.22),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : const [],
        ),
        child: Center(
          child: Icon(icon, size: iconSize, color: Colors.white),
        ),
      ),
    );
  }
}
