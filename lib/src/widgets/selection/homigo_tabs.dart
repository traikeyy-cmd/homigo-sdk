import 'package:flutter/material.dart';

import 'homigo_liquid_segmented_control.dart';

class HomiGoTabs<T> extends StatelessWidget {
  final List<HomiGoSegmentItem<T>> items;
  final T value;
  final ValueChanged<T> onChanged;

  final double height;
  final Color? tintColor;

  const HomiGoTabs({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.height = 54,
    this.tintColor,
  });

  @override
  Widget build(BuildContext context) {
    return HomiGoLiquidSegmentedControl<T>(
      items: items,
      value: value,
      onChanged: onChanged,
      height: height,
      tintColor: tintColor,
    );
  }
}
