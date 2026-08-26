import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  setUp(() async {
    HomiGoSDK.reset();

    await HomiGoSDK.initialize(
      config: const HomiGoConfig(appName: 'HomiGo Native Card Test'),
    );
  });

  tearDown(HomiGoSDK.reset);

  testWidgets('HomiGoGlassCard is native and tappable', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: Scaffold(
          body: Center(
            child: HomiGoGlassCard(
              onTap: () {
                tapped = true;
              },
              child: const Text('Native Card'),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(HomiGoGlassCard), findsOneWidget);
    expect(find.text('Native Card'), findsOneWidget);

    // لا يوجد Glass Blur في البطاقة الجديدة.
    expect(find.byType(BackdropFilter), findsNothing);

    await tester.tap(find.byType(HomiGoGlassCard));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}
