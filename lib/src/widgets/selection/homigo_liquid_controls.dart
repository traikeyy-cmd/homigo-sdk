import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/liquid/homigo_liquid_surface.dart';

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
              HomiGoLiquidSurface(
                width: 28,
                height: 28,
                borderRadius: 9,
                tintColor: brand.primaryColor,
                selected: value,
                tintStrength: value ? 0.12 : 0.025,
                padding: EdgeInsets.zero,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 160),
                    child: value
                        ? Icon(
                            Icons.check_rounded,
                            key: const ValueKey('checked'),
                            size: 18,
                            color: brand.primaryColor,
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onChanged?.call(!value) : null,
        borderRadius: BorderRadius.circular(18),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HomiGoLiquidSurface(
              width: 54,
              height: 32,
              borderRadius: 999,
              tintColor: brand.primaryColor,
              selected: value,
              tintStrength: value ? 0.105 : 0.018,
              padding: const EdgeInsets.all(4),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: value
                        ? brand.primaryColor.withValues(alpha: 0.88)
                        : theme.colorScheme.surface.withValues(alpha: 0.88),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 6,
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
              HomiGoLiquidSurface(
                width: 28,
                height: 28,
                borderRadius: 999,
                tintColor: brand.primaryColor,
                selected: selected,
                tintStrength: selected ? 0.12 : 0.025,
                padding: EdgeInsets.zero,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: selected ? 11 : 0,
                    height: selected ? 11 : 0,
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
