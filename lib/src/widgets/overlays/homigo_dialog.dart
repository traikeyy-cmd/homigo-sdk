import 'package:flutter/material.dart';

import '../cards/homigo_glass_card.dart';

abstract final class HomiGoDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    String? title,
    List<Widget> actions = const [],
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.20),
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);

        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: HomiGoGlassCard(
            borderRadius: 26,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null) ...[
                  Text(title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 14),
                ],
                content,
                if (actions.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: actions,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
