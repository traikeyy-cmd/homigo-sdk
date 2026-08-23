import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/liquid/homigo_liquid_surface.dart';
import '../buttons/homigo_button.dart';
import '../cards/homigo_glass_card.dart';
import 'homigo_dropdown.dart';
import 'homigo_text_field.dart';

class HomiGoSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const HomiGoSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search',
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return HomiGoTextField(
      controller: controller,
      hintText: hintText,
      prefixIcon: Icons.search_rounded,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      suffix: controller == null
          ? null
          : IconButton(
              onPressed: () {
                controller!.clear();
                onChanged?.call('');
                onClear?.call();
              },
              icon: const Icon(Icons.close_rounded),
            ),
    );
  }
}

class HomiGoSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double>? onChanged;
  final String? label;

  const HomiGoSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;

    return HomiGoLiquidSurface(
      borderRadius: 18,
      tintColor: brand.primaryColor,
      tintStrength: 0.018,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: brand.primaryColor.withValues(alpha: 0.75),
          inactiveTrackColor: brand.primaryColor.withValues(alpha: 0.10),
          thumbColor: brand.primaryColor,
          overlayColor: brand.primaryColor.withValues(alpha: 0.10),
          trackHeight: 4,
        ),
        child: Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          label: label,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class HomiGoRangeSlider extends StatelessWidget {
  final RangeValues values;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<RangeValues>? onChanged;

  const HomiGoRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;

    return HomiGoLiquidSurface(
      borderRadius: 18,
      tintColor: brand.primaryColor,
      tintStrength: 0.018,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: brand.primaryColor.withValues(alpha: 0.75),
          inactiveTrackColor: brand.primaryColor.withValues(alpha: 0.10),
          thumbColor: brand.primaryColor,
          overlayColor: brand.primaryColor.withValues(alpha: 0.10),
          trackHeight: 4,
        ),
        child: RangeSlider(
          values: values,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class HomiGoNumberField extends StatelessWidget {
  final num value;
  final num step;
  final num? min;
  final num? max;
  final ValueChanged<num>? onChanged;
  final String? label;

  const HomiGoNumberField({
    super.key,
    required this.value,
    required this.onChanged,
    this.step = 1,
    this.min,
    this.max,
    this.label,
  });

  void _change(num next) {
    if (min != null && next < min!) {
      next = min!;
    }

    if (max != null && next > max!) {
      next = max!;
    }

    onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: theme.textTheme.labelMedium),
          const SizedBox(height: 6),
        ],
        HomiGoLiquidSurface(
          borderRadius: brand.borderRadius,
          tintColor: brand.primaryColor,
          tintStrength: 0.025,
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              _NumberButton(
                icon: Icons.remove_rounded,
                onTap: onChanged == null ? null : () => _change(value - step),
              ),
              Expanded(
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              _NumberButton(
                icon: Icons.add_rounded,
                onTap: onChanged == null ? null : () => _change(value + step),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NumberButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _NumberButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: HomiGoLiquidSurface(
          width: 42,
          height: 42,
          borderRadius: 14,
          tintColor: brand.primaryColor,
          tintStrength: 0.06,
          padding: EdgeInsets.zero,
          child: Center(
            child: Icon(
              icon,
              color: onTap == null
                  ? Theme.of(context).disabledColor
                  : brand.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class HomiGoPhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String hintText;
  final String? countryCode;
  final ValueChanged<String>? onChanged;

  const HomiGoPhoneField({
    super.key,
    this.controller,
    this.label,
    this.hintText = 'Phone number',
    this.countryCode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return HomiGoTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      prefixIcon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s()]')),
      ],
      onChanged: onChanged,
      suffix: countryCode == null
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(widthFactor: 1, child: Text(countryCode!)),
            ),
    );
  }
}

class HomiGoSearchableDropdown<T> extends StatelessWidget {
  final T? value;
  final List<HomiGoDropdownItem<T>> items;
  final ValueChanged<T>? onChanged;
  final String? label;
  final String hintText;
  final String searchHint;

  const HomiGoSearchableDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.hintText = 'Select',
    this.searchHint = 'Search',
  });

  HomiGoDropdownItem<T>? get _selected {
    for (final item in items) {
      if (item.value == value) {
        return item;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return HomiGoDropdown<T>(
      value: value,
      items: items,
      label: label,
      hintText: _selected?.label ?? hintText,
      onChanged: onChanged,
    );
  }

  Future<void> openSearch(BuildContext context) async {
    final controller = TextEditingController();

    final result = await showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final query = controller.text.toLowerCase();

            final filtered = items.where((item) {
              return item.label.toLowerCase().contains(query);
            }).toList();

            return SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                ),
                child: HomiGoGlassCard(
                  borderRadius: 28,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HomiGoTextField(
                        controller: controller,
                        hintText: searchHint,
                        prefixIcon: Icons.search_rounded,
                        onChanged: (_) {
                          setModalState(() {});
                        },
                      ),
                      const SizedBox(height: 12),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final item = filtered[index];

                            return ListTile(
                              leading: item.icon == null
                                  ? null
                                  : Icon(item.icon),
                              title: Text(item.label),
                              onTap: () {
                                Navigator.of(context).pop(item.value);
                              },
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
      },
    );

    controller.dispose();

    if (result != null) {
      onChanged?.call(result);
    }
  }
}

class HomiGoMultiSelect<T> extends StatelessWidget {
  final Set<T> values;
  final List<HomiGoDropdownItem<T>> items;
  final ValueChanged<Set<T>>? onChanged;
  final String? label;
  final String buttonText;

  const HomiGoMultiSelect({
    super.key,
    required this.values,
    required this.items,
    required this.onChanged,
    this.label,
    this.buttonText = 'Select items',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: theme.textTheme.labelMedium),
          const SizedBox(height: 6),
        ],
        HomiGoButton(
          text: values.isEmpty ? buttonText : '${values.length} selected',
          icon: Icons.checklist_rounded,
          variant: HomiGoButtonVariant.outline,
          onPressed: onChanged == null ? null : () => _open(context),
        ),
      ],
    );
  }

  Future<void> _open(BuildContext context) async {
    final working = Set<T>.from(values);

    final result = await showModalBottomSheet<Set<T>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final selected = working.contains(item.value);

                            return CheckboxListTile(
                              value: selected,
                              title: Text(item.label),
                              secondary: item.icon == null
                                  ? null
                                  : Icon(item.icon),
                              onChanged: (checked) {
                                setModalState(() {
                                  if (checked == true) {
                                    working.add(item.value);
                                  } else {
                                    working.remove(item.value);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      HomiGoButton(
                        text: 'Done',
                        onPressed: () {
                          Navigator.of(context).pop(working);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      onChanged?.call(result);
    }
  }
}
