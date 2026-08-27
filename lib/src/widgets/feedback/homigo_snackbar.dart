import 'package:flutter/material.dart';

import '../../design_system/native/homigo_native_surface.dart';
import '../../design_system/theme/homigo_dynamic_colors.dart';
import '../../design_system/tokens/homigo_colors.dart';

enum HomiGoSnackBarVariant { info, success, warning, error }

abstract final class HomiGoSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    HomiGoSnackBarVariant variant = HomiGoSnackBarVariant.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final theme = Theme.of(context);

    final tintColor = switch (variant) {
      HomiGoSnackBarVariant.info => HomiGoDynamicColors.primary(context),
      HomiGoSnackBarVariant.success => HomiGoColors.success,
      HomiGoSnackBarVariant.warning => HomiGoColors.warning,
      HomiGoSnackBarVariant.error => HomiGoColors.error,
    };

    final icon = switch (variant) {
      HomiGoSnackBarVariant.info => Icons.info_outline_rounded,
      HomiGoSnackBarVariant.success => Icons.check_circle_outline_rounded,
      HomiGoSnackBarVariant.warning => Icons.warning_amber_rounded,
      HomiGoSnackBarVariant.error => Icons.error_outline_rounded,
    };

    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        duration: duration,
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.all(16),
        content: HomiGoNativeSurface(
          borderRadius: 18,
          tintColor: tintColor,
          tintStrength: 0.085,
          selected: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Icon(icon, color: tintColor),
              const SizedBox(width: 12),
              Expanded(child: Text(message, style: theme.textTheme.bodyMedium)),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onAction,
                  child: Text(
                    actionLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: tintColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
