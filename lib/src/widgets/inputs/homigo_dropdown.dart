import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/native/homigo_native_surface.dart';
import '../cards/homigo_glass_card.dart';

@immutable
class HomiGoDropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const HomiGoDropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

class HomiGoDropdown<T> extends StatelessWidget {
  final T? value;
  final List<HomiGoDropdownItem<T>> items;
  final ValueChanged<T>? onChanged;

  final String? label;
  final String? hintText;
  final String? sheetTitle;

  final IconData? prefixIcon;

  final bool enabled;
  final double? borderRadius;

  const HomiGoDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.hintText,
    this.sheetTitle,
    this.prefixIcon,
    this.enabled = true,
    this.borderRadius,
  });

  HomiGoDropdownItem<T>? get _selectedItem {
    for (final item in items) {
      if (item.value == value) {
        return item;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    final selected = _selectedItem;
    final active = enabled && onChanged != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, bottom: 6),
            child: Text(label!, style: theme.textTheme.labelMedium),
          ),
        ],
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(
            borderRadius ?? brand.borderRadius,
          ),
          child: InkWell(
            onTap: active ? () => _openItems(context) : null,
            borderRadius: BorderRadius.circular(
              borderRadius ?? brand.borderRadius,
            ),
            splashColor: brand.primaryColor.withValues(alpha: 0.025),
            highlightColor: Colors.transparent,
            child: HomiGoNativeSurface(
              borderRadius: borderRadius ?? brand.borderRadius,
              tintColor: brand.primaryColor,
              tintStrength: 0.030,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  if (prefixIcon != null) ...[
                    Icon(prefixIcon, color: brand.primaryColor),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      selected?.label ?? hintText ?? 'Select',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: selected == null
                            ? theme.textTheme.bodySmall?.color
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: active ? brand.primaryColor : theme.disabledColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openItems(BuildContext context) async {
    final brand = HomiGoSDK.config.brand;

    final result = await showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.18),
      isScrollControlled: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: HomiGoGlassCard(
              borderRadius: 28,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.dividerColor.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  if (sheetTitle != null) ...[
                    const SizedBox(height: 16),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        sheetTitle!,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(sheetContext).size.height * 0.62,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 6),
                      itemBuilder: (itemContext, index) {
                        final item = items[index];
                        final isSelected = item.value == value;

                        return Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(sheetContext).pop(item.value);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: HomiGoNativeSurface(
                              borderRadius: 16,
                              tintColor: brand.primaryColor,
                              selected: isSelected,
                              tintStrength: isSelected ? 0.10 : 0.018,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 13,
                              ),
                              child: Row(
                                children: [
                                  if (item.icon != null) ...[
                                    Icon(
                                      item.icon,
                                      color: isSelected
                                          ? brand.primaryColor
                                          : theme.iconTheme.color,
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: isSelected
                                                ? brand.primaryColor
                                                : null,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : null,
                                          ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_rounded,
                                      color: brand.primaryColor,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      onChanged?.call(result);
    }
  }
}
