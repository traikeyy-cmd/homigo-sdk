import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  setUp(() async {
    HomiGoSDK.reset();

    await HomiGoSDK.initialize(
      config: const HomiGoConfig(appName: 'HomiGo Back Button Test'),
    );
  });

  tearDown(HomiGoSDK.reset);

  testWidgets('HomiGoBackButton supports RTL and calls onPressed', (
    tester,
  ) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Center(
              child: HomiGoBackButton(
                onPressed: () {
                  pressed = true;
                },
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(HomiGoBackButton), findsOneWidget);

    // في RTL يجب أن يشير سهم الرجوع إلى اليمين.
    expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);

    // يجب ألا يستخدم Glass Blur.
    expect(find.byType(BackdropFilter), findsNothing);

    await tester.tap(find.byType(HomiGoBackButton));
    await tester.pumpAndSettle();

    expect(pressed, isTrue);
  });
}
