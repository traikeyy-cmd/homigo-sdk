import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  setUp(() async {
    HomiGoSDK.reset();

    await HomiGoSDK.initialize(
      config: const HomiGoConfig(appName: 'HomiGo Elevated Icon Test'),
    );
  });

  tearDown(HomiGoSDK.reset);

  testWidgets('HomiGoElevatedIcon renders without BackdropFilter', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: const Scaffold(
          body: Center(
            child: HomiGoElevatedIcon(
              icon: Icons.home_rounded,
              color: Color(0xFF6558F5),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(HomiGoElevatedIcon), findsOneWidget);
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.byType(BackdropFilter), findsNothing);
  });
}
