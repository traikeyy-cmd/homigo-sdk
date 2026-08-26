import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/tokens/homigo_colors.dart';

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
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);
    final enabled = onChanged != null;
    final isDark = theme.brightness == Brightness.dark;

    final idleBorder = isDark
        ? HomiGoColors.darkBorder
        : HomiGoColors.lightBorder;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onChanged?.call(!value) : null,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOutCubic,
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: value ? brand.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: value ? brand.primaryColor : idleBorder,
                    width: 1.4,
                  ),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: value
                        ? const Icon(
                            Icons.check_rounded,
                            key: ValueKey('checked'),
                            size: 18,
                            color: Colors.white,
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
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);
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
        borderRadius: BorderRadius.circular(18),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 54,
              height: 32,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: value ? brand.primaryColor : idleBackground,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: value
                      ? brand.primaryColor.withValues(alpha: 0.75)
                      : idleBorder,
                ),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                alignment: value
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
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
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

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
        borderRadius: BorderRadius.circular(14),
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
                    color: selected ? brand.primaryColor : idleBorder,
                    width: selected ? 1.8 : 1.4,
                  ),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeOutCubic,
                    width: selected ? 12 : 0,
                    height: selected ? 12 : 0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: brand.primaryColor,
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
