import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  setUp(() async {
    HomiGoSDK.reset();

    await HomiGoSDK.initialize(
      config: const HomiGoConfig(appName: 'HomiGo Segmented Control Test'),
    );
  });

  tearDown(HomiGoSDK.reset);

  testWidgets(
    'HomiGo segmented control switches value without BackdropFilter',
    (tester) async {
      var selected = 'grid';

      await tester.pumpWidget(
        MaterialApp(
          theme: HomiGoTheme.light(),
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 320,
                    child: HomiGoLiquidSegmentedControl<String>(
                      value: selected,
                      onChanged: (value) {
                        setState(() {
                          selected = value;
                        });
                      },
                      items: const [
                        HomiGoSegmentItem(
                          value: 'grid',
                          label: 'شبكة',
                          icon: Icons.grid_view_rounded,
                        ),
                        HomiGoSegmentItem(
                          value: 'circle',
                          label: 'دوائر',
                          icon: Icons.circle_outlined,
                        ),
                        HomiGoSegmentItem(
                          value: 'cells',
                          label: 'خلايا',
                          icon: Icons.hive_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byType(BackdropFilter), findsNothing);
      expect(selected, 'grid');

      await tester.tap(find.text('خلايا'));
      await tester.pumpAndSettle();

      expect(selected, 'cells');

      await tester.tap(find.text('دوائر'));
      await tester.pumpAndSettle();

      expect(selected, 'circle');
    },
  );
}
