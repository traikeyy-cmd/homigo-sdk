import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  setUp(() async {
    HomiGoSDK.reset();

    await HomiGoSDK.initialize(
      config: const HomiGoConfig(appName: 'HomiGo Native Surface Test'),
    );
  });

  tearDown(HomiGoSDK.reset);

  testWidgets('HomiGoNativeSurface renders without BackdropFilter', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: const Scaffold(
          body: Center(
            child: HomiGoNativeSurface(
              padding: EdgeInsets.all(16),
              child: Text('HomiGo Native UI'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('HomiGo Native UI'), findsOneWidget);
    expect(find.byType(HomiGoNativeSurface), findsOneWidget);

    // أهم اختبار:
    // الـ Native Surface يجب ألا يستخدم Glass Blur.
    expect(find.byType(BackdropFilter), findsNothing);
  });
}
