import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  setUp(() async {
    HomiGoSDK.reset();

    await HomiGoSDK.initialize(
      config: const HomiGoConfig(appName: 'Segmented Compatibility Test'),
    );
  });

  tearDown(HomiGoSDK.reset);

  testWidgets('HomiGoSegmentedControl changes value', (tester) async {
    var value = 'grid';

    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: HomiGoSegmentedControl<String>(
                value: value,
                onChanged: (newValue) {
                  setState(() {
                    value = newValue;
                  });
                },
                items: const [
                  HomiGoSegmentItem(value: 'grid', label: 'شبكة'),
                  HomiGoSegmentItem(value: 'circle', label: 'دوائر'),
                  HomiGoSegmentItem(value: 'cells', label: 'خلايا'),
                ],
              ),
            );
          },
        ),
      ),
    );

    expect(find.byType(HomiGoSegmentedControl<String>), findsOneWidget);

    expect(find.byType(BackdropFilter), findsNothing);

    await tester.tap(find.text('دوائر'));
    await tester.pumpAndSettle();

    expect(value, 'circle');
  });

  testWidgets('old Liquid segmented control delegates to official control', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: Scaffold(
          body: HomiGoLiquidSegmentedControl<String>(
            value: 'a',
            onChanged: (_) {},
            items: const [
              HomiGoSegmentItem(value: 'a', label: 'A'),
              HomiGoSegmentItem(value: 'b', label: 'B'),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(HomiGoLiquidSegmentedControl<String>), findsOneWidget);

    expect(
      find.descendant(
        of: find.byType(HomiGoLiquidSegmentedControl<String>),
        matching: find.byType(HomiGoSegmentedControl<String>),
      ),
      findsOneWidget,
    );

    expect(find.byType(BackdropFilter), findsNothing);
  });
}
