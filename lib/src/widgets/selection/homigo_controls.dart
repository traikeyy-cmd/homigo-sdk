import 'package:flutter/material.dart';

import '../../design_system/theme/homigo_dynamic_colors.dart';
import '../../design_system/tokens/homigo_colors.dart';
import '../../design_system/tokens/homigo_motion.dart';
import '../../design_system/tokens/homigo_radius.dart';

/// Canonical HomiGo checkbox control.
class HomiGoCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  const HomiGoCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = HomiGoDynamicColors.primary(context);
    final enabled = onChanged != null;
    final isDark = theme.brightness == Brightness.dark;

    final idleBorder = isDark
        ? HomiGoColors.darkBorder
        : HomiGoColors.lightBorder;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onChanged?.call(!value) : null,
        borderRadius: BorderRadius.circular(HomiGoRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: HomiGoMotion.standardCurve,
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: value ? primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: value ? primary : idleBorder,
                    width: 1.4,
                  ),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: HomiGoMotion.fast,
                    child: value
                        ? Icon(
                            Icons.check_rounded,
                            key: const ValueKey('checked'),
                            size: 18,
                            color: theme.colorScheme.onPrimary,
                          )
                        : const SizedBox(key: ValueKey('unchecked')),
                  ),
                ),
              ),
              if (label != null) ...[
                const SizedBox(width: 10),
                Text(
                  label!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: enabled ? null : theme.disabledColor,
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

/// Canonical HomiGo switch control.
class HomiGoSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  const HomiGoSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = HomiGoDynamicColors.primary(context);
    final enabled = onChanged != null;
    final isDark = theme.brightness == Brightness.dark;

    final idleBackground = isDark
        ? HomiGoColors.darkSurfaceVariant
        : HomiGoColors.lightSurfaceVariant;

    final idleBorder = isDark
        ? HomiGoColors.darkBorder
        : HomiGoColors.lightBorder;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onChanged?.call(!value) : null,
        borderRadius: BorderRadius.circular(HomiGoRadius.lg),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: HomiGoMotion.standard,
              curve: HomiGoMotion.standardCurve,
              width: 54,
              height: 32,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: value ? primary : idleBackground,
                borderRadius: BorderRadius.circular(HomiGoRadius.pill),
                border: Border.all(
                  color: value ? primary.withValues(alpha: 0.75) : idleBorder,
                ),
              ),
              child: AnimatedAlign(
                duration: HomiGoMotion.standard,
                curve: HomiGoMotion.standardCurve,
                alignment: value
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.onPrimary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (label != null) ...[
              const SizedBox(width: 10),
              Text(
                label!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: enabled ? null : theme.disabledColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Canonical HomiGo radio control.
class HomiGoRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String? label;

  const HomiGoRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = HomiGoDynamicColors.primary(context);

    final selected = value == groupValue;
    final enabled = onChanged != null;
    final isDark = theme.brightness == Brightness.dark;

    final idleBorder = isDark
        ? HomiGoColors.darkBorder
        : HomiGoColors.lightBorder;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onChanged?.call(value) : null,
        borderRadius: BorderRadius.circular(HomiGoRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    color: selected ? primary : idleBorder,
                    width: selected ? 1.8 : 1.4,
                  ),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    curve: HomiGoMotion.standardCurve,
                    width: selected ? 12 : 0,
                    height: selected ? 12 : 0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary,
                    ),
                  ),
                ),
              ),
              if (label != null) ...[
                const SizedBox(width: 10),
                Text(
                  label!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: enabled ? null : theme.disabledColor,
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
