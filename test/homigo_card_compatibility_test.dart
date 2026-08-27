import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  setUp(() async {
    HomiGoSDK.reset();

    await HomiGoSDK.initialize(
      config: const HomiGoConfig(appName: 'HomiGo Card Compatibility Test'),
    );
  });

  tearDown(HomiGoSDK.reset);

  testWidgets('HomiGoCard is native, tappable and has no blur', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: Scaffold(
          body: Center(
            child: HomiGoCard(
              onTap: () {
                tapped = true;
              },
              child: const Text('Official Card'),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(HomiGoCard), findsOneWidget);
    expect(find.text('Official Card'), findsOneWidget);
    expect(find.byType(BackdropFilter), findsNothing);

    await tester.tap(find.text('Official Card'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });

  testWidgets('HomiGoGlassCard delegates to HomiGoCard', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: Scaffold(
          body: Center(
            child: HomiGoGlassCard(
              blur: 24,
              opacity: 0.5,
              onTap: () {
                tapped = true;
              },
              child: const Text('Legacy Card'),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(HomiGoGlassCard), findsOneWidget);

    expect(
      find.descendant(
        of: find.byType(HomiGoGlassCard),
        matching: find.byType(HomiGoCard),
      ),
      findsOneWidget,
    );

    expect(find.byType(BackdropFilter), findsNothing);

    await tester.tap(find.text('Legacy Card'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });

  testWidgets('HomiGoCard supports custom app content', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: Scaffold(
          body: HomiGoCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                HomiGoElevatedIcon(icon: Icons.schedule_rounded),
                SizedBox(height: 10),
                Text('Custom Application Card'),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Custom Application Card'), findsOneWidget);

    expect(find.byType(HomiGoElevatedIcon), findsOneWidget);

    expect(find.byType(BackdropFilter), findsNothing);
  });
}
