import 'package:flutter/material.dart';

import '../../design_system/tokens/homigo_radius.dart';
import '../../platform/system_ui/homigo_insets.dart';
import '../cards/homigo_glass_card.dart';

abstract final class HomiGoBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool showHandle = true,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool useSafeArea = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.18),
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      useSafeArea: false,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);

        Widget sheet = Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: HomiGoGlassCard(
            borderRadius: HomiGoRadius.xxl,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showHandle) ...[
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.dividerColor.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(HomiGoRadius.pill),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                if (title != null) ...[
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(title, style: theme.textTheme.titleLarge),
                  ),
                  const SizedBox(height: 16),
                ],
                child,
              ],
            ),
          ),
        );

        sheet = HomiGoKeyboardInsets(
          includeBottomSystemInset: true,
          child: sheet,
        );

        if (useSafeArea) {
          sheet = HomiGoSafeArea(
            top: false,
            maintainBottomViewPadding: true,
            child: sheet,
          );
        }

        return sheet;
      },
    );
  }
}
