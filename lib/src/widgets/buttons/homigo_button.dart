import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/liquid/homigo_liquid_surface.dart';
import '../../design_system/tokens/homigo_colors.dart';
import '../../design_system/tokens/homigo_typography.dart';

/// الشكل البصري للزر.
enum HomiGoButtonVariant { primary, secondary, outline, ghost, danger }

/// حجم الزر.
enum HomiGoButtonSize { small, medium, large }

/// زر مائي موحد لجميع التطبيقات التي تستخدم HomiGo SDK.
///
/// لا يستخدم خلفيات مصمتة أو Border تقليدي.
/// يعتمد على HomiGoLiquidSurface لإظهار:
/// - Water Glass
/// - Tint خفيف
/// - حواف محفورة
/// - انعكاسات ضوئية
/// - استجابة مائية عند الضغط
class HomiGoButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;

  final HomiGoButtonVariant variant;
  final HomiGoButtonSize size;

  final bool isLoading;
  final bool fullWidth;

  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;

  final double? borderRadius;

  const HomiGoButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = HomiGoButtonVariant.primary,
    this.size = HomiGoButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
    this.leading,
    this.trailing,
    this.borderRadius,
  });

  @override
  State<HomiGoButton> createState() => _HomiGoButtonState();
}

class _HomiGoButtonState extends State<HomiGoButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;

    final height = switch (widget.size) {
      HomiGoButtonSize.small => 42.0,
      HomiGoButtonSize.medium => 52.0,
      HomiGoButtonSize.large => 60.0,
    };

    final horizontalPadding = switch (widget.size) {
      HomiGoButtonSize.small => 14.0,
      HomiGoButtonSize.medium => 18.0,
      HomiGoButtonSize.large => 22.0,
    };

    final textStyle = switch (widget.size) {
      HomiGoButtonSize.small => HomiGoTypography.labelMedium,
      HomiGoButtonSize.medium => HomiGoTypography.labelLarge,
      HomiGoButtonSize.large => HomiGoTypography.labelLarge.copyWith(
        fontSize: 16,
      ),
    };

    final tintColor = _tintColor();
    final foregroundColor = _foregroundColor(context);

    final tintStrength = _tintStrength();

    final radius = widget.borderRadius ?? brand.borderRadius;

    final buttonContent = _ButtonContent(
      text: widget.text,
      isLoading: widget.isLoading,
      icon: widget.icon,
      leading: widget.leading,
      trailing: widget.trailing,
      foregroundColor: foregroundColor,
      textStyle: textStyle,
    );

    final liquidButton = HomiGoLiquidSurface(
      width: widget.fullWidth ? double.infinity : null,
      height: height,
      borderRadius: radius,
      tintColor: tintColor,
      tintStrength: _pressed ? tintStrength * 1.35 : tintStrength,
      selected: _pressed,
      enabled: true,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 140),
          opacity: _enabled ? 1.0 : 0.46,
          child: buttonContent,
        ),
      ),
    );

    return AnimatedScale(
      scale: _pressed ? 0.985 : 1.0,
      duration: const Duration(milliseconds: 110),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: _enabled ? widget.onPressed : null,
          onHighlightChanged: _enabled
              ? (pressed) {
                  setState(() {
                    _pressed = pressed;
                  });
                }
              : null,
          splashColor: tintColor.withValues(alpha: 0.035),
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          child: liquidButton,
        ),
      ),
    );
  }

  Color _tintColor() {
    final brand = HomiGoSDK.config.brand;

    return switch (widget.variant) {
      HomiGoButtonVariant.primary => brand.primaryColor,
      HomiGoButtonVariant.secondary => brand.secondaryColor,
      HomiGoButtonVariant.outline => brand.primaryColor,
      HomiGoButtonVariant.ghost => brand.primaryColor,
      HomiGoButtonVariant.danger => HomiGoColors.error,
    };
  }

  double _tintStrength() {
    return switch (widget.variant) {
      HomiGoButtonVariant.primary => 0.12,
      HomiGoButtonVariant.secondary => 0.11,
      HomiGoButtonVariant.outline => 0.060,
      HomiGoButtonVariant.ghost => 0.025,
      HomiGoButtonVariant.danger => 0.10,
    };
  }

  Color _foregroundColor(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    final normalText = theme.brightness == Brightness.dark
        ? HomiGoColors.darkTextPrimary
        : HomiGoColors.lightTextPrimary;

    return switch (widget.variant) {
      HomiGoButtonVariant.primary => brand.primaryColor,
      HomiGoButtonVariant.secondary => brand.secondaryColor,
      HomiGoButtonVariant.outline => brand.primaryColor,
      HomiGoButtonVariant.ghost => normalText,
      HomiGoButtonVariant.danger => HomiGoColors.error,
    };
  }
}

class _ButtonContent extends StatelessWidget {
  final String text;
  final bool isLoading;

  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;

  final Color foregroundColor;
  final TextStyle textStyle;

  const _ButtonContent({
    required this.text,
    required this.isLoading,
    required this.icon,
    required this.leading,
    required this.trailing,
    required this.foregroundColor,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    }

    final effectiveLeading =
        leading ??
        switch (icon) {
          final iconData? => Icon(iconData, size: 20, color: foregroundColor),
          null => null,
        };

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (effectiveLeading != null) ...[
          effectiveLeading,
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textStyle.copyWith(color: foregroundColor),
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}
