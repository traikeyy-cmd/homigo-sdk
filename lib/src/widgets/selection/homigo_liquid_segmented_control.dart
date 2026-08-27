import 'package:flutter/material.dart';

import 'homigo_segmented_control.dart';

export 'homigo_segmented_control.dart' show HomiGoSegmentItem;

/// Compatibility wrapper.
///
/// الاسم القديم محفوظ حتى لا تنكسر التطبيقات الحالية.
/// التنفيذ الفعلي أصبح [HomiGoSegmentedControl].
class HomiGoLiquidSegmentedControl<T> extends StatelessWidget {
  final List<HomiGoSegmentItem<T>> items;
  final T value;
  final ValueChanged<T> onChanged;

  final double height;
  final double? borderRadius;

  final Color? tintColor;

  final EdgeInsetsGeometry margin;

  const HomiGoLiquidSegmentedControl({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.height = 54,
    this.borderRadius,
    this.tintColor,
    this.margin = EdgeInsets.zero,
  }) : assert(items.length > 1);

  @override
  Widget build(BuildContext context) {
    return HomiGoSegmentedControl<T>(
      items: items,
      value: value,
      onChanged: onChanged,
      height: height,
      borderRadius: borderRadius,
      tintColor: tintColor,
      margin: margin,
    );
  }
}
