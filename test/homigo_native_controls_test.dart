import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  setUp(() async {
    HomiGoSDK.reset();

    await HomiGoSDK.initialize(
      config: const HomiGoConfig(appName: 'HomiGo Native Controls Test'),
    );
  });

  tearDown(HomiGoSDK.reset);

  testWidgets('native selection controls work without BackdropFilter', (
    tester,
  ) async {
    var checked = false;
    var switched = false;
    var selectedRadio = 1;

    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: Column(
                children: [
                  HomiGoCheckbox(
                    value: checked,
                    label: 'Checkbox',
                    onChanged: (value) {
                      setState(() {
                        checked = value;
                      });
                    },
                  ),
                  HomiGoSwitch(
                    value: switched,
                    label: 'Switch',
                    onChanged: (value) {
                      setState(() {
                        switched = value;
                      });
                    },
                  ),
                  HomiGoRadio<int>(
                    value: 2,
                    groupValue: selectedRadio,
                    label: 'Radio',
                    onChanged: (value) {
                      setState(() {
                        selectedRadio = value;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    expect(find.byType(BackdropFilter), findsNothing);

    await tester.tap(find.text('Checkbox'));
    await tester.pumpAndSettle();
    expect(checked, isTrue);

    await tester.tap(find.text('Switch'));
    await tester.pumpAndSettle();
    expect(switched, isTrue);

    await tester.tap(find.text('Radio'));
    await tester.pumpAndSettle();
    expect(selectedRadio, 2);
  });
}
