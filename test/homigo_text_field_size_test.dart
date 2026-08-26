import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  setUp(() async {
    HomiGoSDK.reset();

    await HomiGoSDK.initialize(
      config: const HomiGoConfig(appName: 'HomiGo Field Size Test'),
    );
  });

  tearDown(HomiGoSDK.reset);

  testWidgets('HomiGoTextField uses different heights based on field purpose', (
    tester,
  ) async {
    const compactKey = Key('compact');
    const standardKey = Key('standard');
    const largeKey = Key('large');
    const multilineKey = Key('multiline');

    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: const Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                HomiGoTextField(
                  key: compactKey,
                  hintText: 'Compact',
                  size: HomiGoFieldSize.compact,
                ),
                SizedBox(height: 12),
                HomiGoTextField(
                  key: standardKey,
                  hintText: 'Standard',
                  size: HomiGoFieldSize.standard,
                ),
                SizedBox(height: 12),
                HomiGoTextField(
                  key: largeKey,
                  hintText: 'Large',
                  size: HomiGoFieldSize.large,
                ),
                SizedBox(height: 12),
                HomiGoTextField(
                  key: multilineKey,
                  hintText: 'Description',
                  minLines: 4,
                  maxLines: 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final compactHeight = tester.getSize(find.byKey(compactKey)).height;
    final standardHeight = tester.getSize(find.byKey(standardKey)).height;
    final largeHeight = tester.getSize(find.byKey(largeKey)).height;
    final multilineHeight = tester.getSize(find.byKey(multilineKey)).height;

    expect(compactHeight, lessThan(standardHeight));
    expect(standardHeight, lessThan(largeHeight));
    expect(multilineHeight, greaterThan(largeHeight));

    // النظام الجديد لا يجب أن يرجع لاستخدام Glass Blur.
    expect(find.byType(BackdropFilter), findsNothing);
  });
}
