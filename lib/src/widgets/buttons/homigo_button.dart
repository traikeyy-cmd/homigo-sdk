import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/native/homigo_native_surface.dart';
import '../../design_system/tokens/homigo_colors.dart';
import '../../design_system/tokens/homigo_motion.dart';
import '../../design_system/tokens/homigo_typography.dart';

/// الشكل البصري للزر.
enum HomiGoButtonVariant { primary, secondary, outline, ghost, danger }

/// حجم الزر.
enum HomiGoButtonSize { small, medium, large }

/// زر HomiGo الموحد بنظام Native UI.
///
/// - بدون Glass أو Blur.
/// - يحافظ على نفس API الإصدارات السابقة.
/// - يدعم حالات الضغط والتحميل والتعطيل.
/// - يحتوي على Micro Animation خفيفة عند الضغط.
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

  void _setPressed(bool value) {
    if (_pressed == value || !mounted) {
      return;
    }

    setState(() {
      _pressed = value;
    });
  }

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

    final radius = widget.borderRadius ?? brand.borderRadius;

    final backgroundColor = _backgroundColor(context);
    final borderColor = _borderColor(context);
    final foregroundColor = _foregroundColor(context);

    final filled = switch (widget.variant) {
      HomiGoButtonVariant.primary ||
      HomiGoButtonVariant.secondary ||
      HomiGoButtonVariant.danger => true,
      HomiGoButtonVariant.outline || HomiGoButtonVariant.ghost => false,
    };

    final buttonContent = _ButtonContent(
      text: widget.text,
      isLoading: widget.isLoading,
      icon: widget.icon,
      leading: widget.leading,
      trailing: widget.trailing,
      foregroundColor: foregroundColor,
      textStyle: textStyle,
    );

    return Semantics(
      button: true,
      enabled: _enabled,
      child: AnimatedScale(
        scale: _pressed ? HomiGoMotion.pressedScale : 1.0,
        duration: HomiGoMotion.fast,
        curve: HomiGoMotion.standardCurve,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _enabled ? (_) => _setPressed(true) : null,
          onTapUp: _enabled ? (_) => _setPressed(false) : null,
          onTapCancel: _enabled ? () => _setPressed(false) : null,
          onTap: _enabled ? widget.onPressed : null,
          child: HomiGoNativeSurface(
            width: widget.fullWidth ? double.infinity : null,
            height: height,
            borderRadius: radius,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            enabled: _enabled || widget.isLoading,
            elevated: filled,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Center(child: buttonContent),
          ),
        ),
      ),
    );
  }

  Color _backgroundColor(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    final surface = theme.brightness == Brightness.dark
        ? HomiGoColors.darkSurface
        : HomiGoColors.lightSurface;

    return switch (widget.variant) {
      HomiGoButtonVariant.primary => brand.primaryColor,
      HomiGoButtonVariant.secondary => brand.secondaryColor,
      HomiGoButtonVariant.outline => surface,
      HomiGoButtonVariant.ghost => Colors.transparent,
      HomiGoButtonVariant.danger => HomiGoColors.error,
    };
  }

  Color _borderColor(BuildContext context) {
    final brand = HomiGoSDK.config.brand;

    return switch (widget.variant) {
      HomiGoButtonVariant.primary => brand.primaryColor,
      HomiGoButtonVariant.secondary => brand.secondaryColor,
      HomiGoButtonVariant.outline => brand.primaryColor.withValues(alpha: 0.45),
      HomiGoButtonVariant.ghost => Colors.transparent,
      HomiGoButtonVariant.danger => HomiGoColors.error,
    };
  }

  Color _foregroundColor(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    final normalText = theme.brightness == Brightness.dark
        ? HomiGoColors.darkTextPrimary
        : HomiGoColors.lightTextPrimary;

    return switch (widget.variant) {
      HomiGoButtonVariant.primary => Colors.white,
      HomiGoButtonVariant.secondary => Colors.white,
      HomiGoButtonVariant.outline => brand.primaryColor,
      HomiGoButtonVariant.ghost => normalText,
      HomiGoButtonVariant.danger => Colors.white,
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
