import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/tokens/homigo_colors.dart';
import '../../design_system/tokens/homigo_typography.dart';

/// الشكل البصري للزر.
enum HomiGoButtonVariant { primary, secondary, outline, ghost, danger }

/// حجم الزر.
enum HomiGoButtonSize { small, medium, large }

/// الزر الموحد لجميع التطبيقات التي تستخدم HomiGo SDK.
class HomiGoButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    final radius = BorderRadius.circular(borderRadius ?? brand.borderRadius);

    final height = switch (size) {
      HomiGoButtonSize.small => 42.0,
      HomiGoButtonSize.medium => 52.0,
      HomiGoButtonSize.large => 60.0,
    };

    final horizontalPadding = switch (size) {
      HomiGoButtonSize.small => 14.0,
      HomiGoButtonSize.medium => 18.0,
      HomiGoButtonSize.large => 22.0,
    };

    final textStyle = switch (size) {
      HomiGoButtonSize.small => HomiGoTypography.labelMedium,
      HomiGoButtonSize.medium => HomiGoTypography.labelLarge,
      HomiGoButtonSize.large => HomiGoTypography.labelLarge.copyWith(
        fontSize: 16,
      ),
    };

    final foregroundColor = _foregroundColor(context, variant);

    final backgroundColor = _backgroundColor(context, variant);

    final disabledBackgroundColor = backgroundColor?.withValues(alpha: 0.55);

    final disabledForegroundColor = foregroundColor.withValues(alpha: 0.65);

    final minimumSize = Size(fullWidth ? double.infinity : 0, height);

    final content = _ButtonContent(
      text: text,
      isLoading: isLoading,
      icon: icon,
      leading: leading,
      trailing: trailing,
      foregroundColor: foregroundColor,
      textStyle: textStyle,
    );

    final effectiveOnPressed = isLoading ? null : onPressed;

    Widget button;

    switch (variant) {
      case HomiGoButtonVariant.primary:
      case HomiGoButtonVariant.secondary:
      case HomiGoButtonVariant.danger:
        button = FilledButton(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            minimumSize: minimumSize,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            elevation: 0,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            disabledBackgroundColor: disabledBackgroundColor,
            disabledForegroundColor: disabledForegroundColor,
            shape: RoundedRectangleBorder(borderRadius: radius),
            textStyle: textStyle,
          ),
          child: content,
        );

      case HomiGoButtonVariant.outline:
        button = OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: minimumSize,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            elevation: 0,
            foregroundColor: foregroundColor,
            disabledForegroundColor: disabledForegroundColor,
            side: BorderSide(
              color: onPressed == null
                  ? theme.dividerColor.withValues(alpha: 0.5)
                  : brand.primaryColor,
              width: 1.2,
            ),
            shape: RoundedRectangleBorder(borderRadius: radius),
            textStyle: textStyle,
          ),
          child: content,
        );

      case HomiGoButtonVariant.ghost:
        button = TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            minimumSize: minimumSize,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            elevation: 0,
            foregroundColor: foregroundColor,
            disabledForegroundColor: disabledForegroundColor,
            shape: RoundedRectangleBorder(borderRadius: radius),
            textStyle: textStyle,
          ),
          child: content,
        );
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Color _foregroundColor(BuildContext context, HomiGoButtonVariant variant) {
    final brand = HomiGoSDK.config.brand;

    return switch (variant) {
      HomiGoButtonVariant.primary => Colors.white,
      HomiGoButtonVariant.secondary => Colors.white,
      HomiGoButtonVariant.outline => brand.primaryColor,
      HomiGoButtonVariant.ghost => brand.primaryColor,
      HomiGoButtonVariant.danger => Colors.white,
    };
  }

  Color? _backgroundColor(BuildContext context, HomiGoButtonVariant variant) {
    final brand = HomiGoSDK.config.brand;

    return switch (variant) {
      HomiGoButtonVariant.primary => brand.primaryColor,
      HomiGoButtonVariant.secondary => brand.secondaryColor,
      HomiGoButtonVariant.outline => null,
      HomiGoButtonVariant.ghost => null,
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
          final iconData? => Icon(iconData, size: 20),
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
