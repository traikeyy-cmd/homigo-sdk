import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  setUp(() async {
    HomiGoSDK.reset();

    await HomiGoSDK.initialize(
      config: const HomiGoConfig(appName: 'HomiGo Navigation Test'),
    );
  });

  tearDown(HomiGoSDK.reset);

  testWidgets('HomiGoNavigationBar is native and switches destination', (
    tester,
  ) async {
    var selectedIndex = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: HomiGoTheme.light(),
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              bottomNavigationBar: HomiGoNavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                items: const [
                  HomiGoNavigationItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: 'Home',
                  ),
                  HomiGoNavigationItem(
                    icon: Icons.receipt_long_outlined,
                    activeIcon: Icons.receipt_long_rounded,
                    label: 'Orders',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    expect(find.byType(HomiGoNavigationBar), findsOneWidget);
    expect(find.byType(BackdropFilter), findsNothing);

    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);

    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();

    expect(selectedIndex, 1);
    expect(find.byIcon(Icons.receipt_long_rounded), findsOneWidget);
  });
}
