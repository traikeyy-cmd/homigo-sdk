import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/tokens/homigo_colors.dart';
import '../buttons/homigo_button.dart';
import '../cards/homigo_glass_card.dart';

class HomiGoLoadingState extends StatelessWidget {
  final String? message;

  const HomiGoLoadingState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: HomiGoGlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: brand.primaryColor,
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class HomiGoEmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;

  final String? actionLabel;
  final VoidCallback? onAction;

  const HomiGoEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return _HomiGoStateView(
      title: title,
      message: message,
      icon: icon,
      tintColor: HomiGoSDK.config.brand.primaryColor,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

class HomiGoErrorState extends StatelessWidget {
  final String title;
  final String? message;

  final String? actionLabel;
  final VoidCallback? onAction;

  const HomiGoErrorState({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return _HomiGoStateView(
      title: title,
      message: message,
      icon: Icons.error_outline_rounded,
      tintColor: HomiGoColors.error,
      actionLabel: actionLabel,
      onAction: onAction,
      actionVariant: HomiGoButtonVariant.danger,
    );
  }
}

class _HomiGoStateView extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;

  final Color tintColor;

  final String? actionLabel;
  final VoidCallback? onAction;

  final HomiGoButtonVariant actionVariant;

  const _HomiGoStateView({
    required this.title,
    required this.message,
    required this.icon,
    required this.tintColor,
    required this.actionLabel,
    required this.onAction,
    this.actionVariant = HomiGoButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: HomiGoGlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tintColor.withValues(alpha: 0.08),
                ),
                child: Icon(icon, size: 30, color: tintColor),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 18),
                HomiGoButton(
                  text: actionLabel!,
                  variant: actionVariant,
                  onPressed: onAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
