import 'package:flutter/material.dart';

import '../buttons/homigo_button.dart';

String _two(int value) => value.toString().padLeft(2, '0');

String _dateText(DateTime date) {
  return '${date.year}-${_two(date.month)}-${_two(date.day)}';
}

String _timeText(TimeOfDay time) {
  return '${_two(time.hour)}:${_two(time.minute)}';
}

class HomiGoDatePicker extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final String emptyText;

  const HomiGoDatePicker({
    super.key,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.emptyText = 'Select date',
  });

  @override
  Widget build(BuildContext context) {
    return HomiGoButton(
      text: value == null ? emptyText : _dateText(value!),
      icon: Icons.calendar_month_outlined,
      variant: HomiGoButtonVariant.outline,
      onPressed: onChanged == null
          ? null
          : () async {
              final now = DateTime.now();

              final selected = await showDatePicker(
                context: context,
                initialDate: value ?? now,
                firstDate: firstDate,
                lastDate: lastDate,
              );

              if (selected != null) {
                onChanged?.call(selected);
              }
            },
    );
  }
}

class HomiGoTimePicker extends StatelessWidget {
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay>? onChanged;
  final String emptyText;

  const HomiGoTimePicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.emptyText = 'Select time',
  });

  @override
  Widget build(BuildContext context) {
    return HomiGoButton(
      text: value == null ? emptyText : _timeText(value!),
      icon: Icons.schedule_rounded,
      variant: HomiGoButtonVariant.outline,
      onPressed: onChanged == null
          ? null
          : () async {
              final selected = await showTimePicker(
                context: context,
                initialTime: value ?? TimeOfDay.now(),
              );

              if (selected != null) {
                onChanged?.call(selected);
              }
            },
    );
  }
}

class HomiGoDateRangePicker extends StatelessWidget {
  final DateTimeRange? value;
  final ValueChanged<DateTimeRange>? onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final String emptyText;

  const HomiGoDateRangePicker({
    super.key,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.emptyText = 'Select date range',
  });

  @override
  Widget build(BuildContext context) {
    final text = value == null
        ? emptyText
        : '${_dateText(value!.start)}  →  ${_dateText(value!.end)}';

    return HomiGoButton(
      text: text,
      icon: Icons.date_range_outlined,
      variant: HomiGoButtonVariant.outline,
      onPressed: onChanged == null
          ? null
          : () async {
              final selected = await showDateRangePicker(
                context: context,
                initialDateRange: value,
                firstDate: firstDate,
                lastDate: lastDate,
              );

              if (selected != null) {
                onChanged?.call(selected);
              }
            },
    );
  }
}
