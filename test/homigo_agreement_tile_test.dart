import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  setUp(() async {
    HomiGoSDK.reset();

    await HomiGoSDK.initialize(
      config: const HomiGoConfig(appName: 'HomiGo Agreement Tile Test'),
    );
  });

  tearDown(HomiGoSDK.reset);

  testWidgets('HomiGoAgreementTile toggles and expands with long text', (
    tester,
  ) async {
    var accepted = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: Center(
                child: SizedBox(
                  width: 320,
                  child: HomiGoAgreementTile(
                    value: accepted,
                    text:
                        'أوافق على الشروط والأحكام وسياسة الخصوصية الخاصة باستخدام خدمات HomiGo والمتابعة في استخدام التطبيق.',
                    helperText:
                        'يرجى قراءة الشروط والأحكام بعناية قبل المتابعة.',
                    onChanged: (value) {
                      setState(() {
                        accepted = value;
                      });
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    expect(find.byType(HomiGoAgreementTile), findsOneWidget);
    expect(find.byType(BackdropFilter), findsNothing);

    final initialHeight = tester
        .getSize(find.byType(HomiGoAgreementTile))
        .height;

    expect(initialHeight, greaterThan(60));

    await tester.tap(find.byType(HomiGoAgreementTile));
    await tester.pumpAndSettle();

    expect(accepted, isTrue);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });
}
