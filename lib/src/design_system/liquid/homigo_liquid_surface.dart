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
        (selected ? tintStrength * 1.45 : tintStrength)
            .clamp(0.0, 1.0)
            .toDouble();

    final surfaceOpacity = isDark ? 0.24 : 0.30;

    final topHighlight = isDark ? 0.15 : 0.52;
    final lowerShade = isDark ? 0.18 : 0.08;

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
              // ------------------------------------------------
              // Water body
              // ------------------------------------------------
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: effectiveRadius,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(
                        alpha: isDark ? 0.08 : surfaceOpacity,
                      ),
                      tint.withValues(alpha: effectiveTintStrength),
                      isDark
                          ? Colors.black.withValues(alpha: 0.12)
                          : Colors.white.withValues(alpha: 0.12),
                    ],
                    stops: const [0.0, 0.56, 1.0],
                  ),
                  boxShadow: [
                    // الضوء الخارجي العلوي.
                    BoxShadow(
                      color: Colors.white.withValues(
                        alpha: isDark ? 0.04 : 0.28,
                      ),
                      offset: const Offset(-1.5, -1.5),
                      blurRadius: 4,
                    ),

                    // الظل السفلي يعطي إحساس العمق.
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.30 : 0.10,
                      ),
                      offset: const Offset(2, 3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const SizedBox.expand(),
              ),

              // ------------------------------------------------
              // Carved upper edge
              // لا يوجد Border مباشر.
              // ------------------------------------------------
              Positioned(
                top: 0,
                left: radius * 0.45,
                right: radius * 0.45,
                height: 1.4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: topHighlight),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ------------------------------------------------
              // Carved lower edge
              // ------------------------------------------------
              Positioned(
                bottom: 0,
                left: radius * 0.55,
                right: radius * 0.55,
                height: 1.2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: lowerShade),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ------------------------------------------------
              // Soft internal reflection
              // ------------------------------------------------
              Positioned(
                top: -35,
                left: -20,
                right: 20,
                height: 65,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius * 2),
                      gradient: RadialGradient(
                        center: Alignment.topLeft,
                        radius: 1.2,
                        colors: [
                          Colors.white.withValues(alpha: isDark ? 0.08 : 0.24),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ------------------------------------------------
              // Selected liquid glow
              // ------------------------------------------------
              if (selected)
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: effectiveRadius,
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.0,
                          colors: [
                            tint.withValues(alpha: 0.10),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // ------------------------------------------------
              // Content
              // ------------------------------------------------
              Padding(padding: padding ?? EdgeInsets.zero, child: child),
            ],
          ),
        ),
      ),
    );
  }
}
