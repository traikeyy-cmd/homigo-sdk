import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';

/// السطح المائي الأساسي في HomiGo SDK.
///
/// هذا المكون هو الأساس المشترك للأزرار والبطاقات
/// والتبويبات والاختيارات وبقية المكونات المائية.
class HomiGoLiquidSurface extends StatelessWidget {
  final Widget child;

  final Color? tintColor;

  final double? borderRadius;
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
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final radius = borderRadius ?? brand.borderRadius;
    final effectiveBlur = blur ?? brand.glassBlur;

    final tint = tintColor ?? brand.primaryColor;

    final effectiveTintStrength =
        (selected ? tintStrength * 1.35 : tintStrength)
            .clamp(0.0, 1.0)
            .toDouble();

    final effectiveRadius = BorderRadius.circular(radius);

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: enabled ? effectiveBlur : 0,
          sigmaY: enabled ? effectiveBlur : 0,
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              // ==================================================
              // WATER BODY
              // جسم مائي شفاف جدًا.
              // لا يوجد لون أبيض مصمت ولا Border.
              // ==================================================
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: effectiveRadius,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: isDark ? 0.045 : 0.075),
                        tint.withValues(alpha: effectiveTintStrength * 0.42),
                        Colors.white.withValues(alpha: isDark ? 0.015 : 0.025),
                      ],
                      stops: const [0.0, 0.56, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(
                          alpha: isDark ? 0.025 : 0.14,
                        ),
                        offset: const Offset(-2, -2),
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.22 : 0.055,
                        ),
                        offset: const Offset(2, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                ),
              ),

              // ==================================================
              // SOFT TOP REFLECTION
              // انعكاس الماء من الأعلى.
              // ==================================================
              Positioned(
                top: -42,
                left: -25,
                right: 10,
                height: 82,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius * 2.2),
                      gradient: RadialGradient(
                        center: Alignment.topLeft,
                        radius: 1.15,
                        colors: [
                          Colors.white.withValues(alpha: isDark ? 0.06 : 0.16),
                          Colors.white.withValues(
                            alpha: isDark ? 0.015 : 0.025,
                          ),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.52, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // CARVED TOP EDGE
              // ضوء رفيع غير كامل يعطي إحساس الحفر.
              // ==================================================
              Positioned(
                top: 0.4,
                left: radius * 0.70,
                right: radius * 0.70,
                height: 1,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: isDark ? 0.12 : 0.34),
                          Colors.white.withValues(alpha: isDark ? 0.07 : 0.18),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.30, 0.70, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // CARVED LOWER EDGE
              // ظل داخلي خفيف أسفل السطح.
              // ==================================================
              Positioned(
                bottom: 0.4,
                left: radius * 0.85,
                right: radius * 0.85,
                height: 1,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: isDark ? 0.14 : 0.055),
                          Colors.black.withValues(alpha: isDark ? 0.10 : 0.035),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.32, 0.68, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // SIDE LIGHT
              // انعكاس جانبي يكسر شكل المستطيل التقليدي.
              // ==================================================
              Positioned(
                top: radius * 0.8,
                bottom: radius * 0.8,
                left: 0.4,
                width: 1,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: isDark ? 0.06 : 0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // SELECTED WATER GLOW
              // الاختيار لا يصبح كتلة ملونة.
              // مجرد Tint داخلي مائي.
              // ==================================================
              if (selected)
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: effectiveRadius,
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.15,
                          colors: [
                            tint.withValues(alpha: 0.075),
                            tint.withValues(alpha: 0.025),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

              // ==================================================
              // CONTENT
              // ==================================================
              Padding(padding: padding ?? EdgeInsets.zero, child: child),
            ],
          ),
        ),
      ),
    );
  }
}
