import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  setUp(() async {
    HomiGoSDK.reset();

    await HomiGoSDK.initialize(
      config: const HomiGoConfig(appName: 'HomiGo Native Button Test'),
    );
  });

  tearDown(HomiGoSDK.reset);

  testWidgets('HomiGoButton works without BackdropFilter', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: Scaffold(
          body: Center(
            child: HomiGoButton(
              text: 'Continue',
              icon: Icons.arrow_forward_rounded,
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.byType(HomiGoButton), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.byType(BackdropFilter), findsNothing);

    await tester.tap(find.byType(HomiGoButton));
    await tester.pumpAndSettle();

    expect(pressed, isTrue);
  });

  testWidgets('HomiGoButton loading state disables tap', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: Scaffold(
          body: Center(
            child: HomiGoButton(
              text: 'Loading',
              isLoading: true,
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byType(HomiGoButton));
    await tester.pump();

    expect(pressed, isFalse);
  });
}
