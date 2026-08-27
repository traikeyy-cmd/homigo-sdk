import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';
import 'package:homigo_sdk/src/widgets/selection/homigo_liquid_controls.dart'
    as legacy_controls;

void main() {
  setUp(() async {
    HomiGoSDK.reset();
    await HomiGoSDK.initialize(
      config: const HomiGoConfig(appName: 'HomiGo Native Design System Test'),
    );
  });

  tearDown(HomiGoSDK.reset);

  testWidgets('canonical controls remain available through legacy import', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: Scaffold(
          body: legacy_controls.HomiGoCheckbox(
            value: true,
            onChanged: (_) {},
            label: 'Legacy import',
          ),
        ),
      ),
    );

    expect(find.byType(HomiGoCheckbox), findsOneWidget);
    expect(find.text('Legacy import'), findsOneWidget);
    expect(find.byType(BackdropFilter), findsNothing);
  });

  testWidgets('generic card supports dark selected and disabled states', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.dark(),
        home: const Scaffold(
          body: HomiGoCard(
            selected: true,
            enabled: false,
            child: Text('Dark card'),
          ),
        ),
      ),
    );

    expect(find.byType(HomiGoCard), findsOneWidget);
    expect(find.text('Dark card'), findsOneWidget);
    expect(find.byType(HomiGoNativeSurface), findsOneWidget);
    expect(find.byType(BackdropFilter), findsNothing);
  });

  testWidgets('official segmented control composes arbitrary app filters', (
    tester,
  ) async {
    var value = 'open';

    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: HomiGoSegmentedControl<String>(
                value: value,
                items: const [
                  HomiGoSegmentItem(value: 'open', label: 'Open'),
                  HomiGoSegmentItem(value: 'done', label: 'Done'),
                ],
                onChanged: (next) {
                  setState(() => value = next);
                },
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(value, 'done');
    expect(find.byType(BackdropFilter), findsNothing);
  });
}
