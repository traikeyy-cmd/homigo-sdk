import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  const brandPrimary = Color(0xFF4C8BF5);
  const dynamicPrimary = Color(0xFF006C4C);
  const dynamicSecondary = Color(0xFF4D6358);

  setUp(() async {
    HomiGoSDK.reset();
    await HomiGoSDK.initialize(
      config: const HomiGoConfig(
        appName: 'Dynamic Color Test',
        brand: HomiGoBrand(
          primaryColor: brandPrimary,
          secondaryColor: Color(0xFFFF8A00),
        ),
      ),
    );
  });

  tearDown(HomiGoSDK.reset);

  testWidgets('core visual primitives follow host ColorScheme', (tester) async {
    final scheme = ColorScheme.fromSeed(
      seedColor: dynamicPrimary,
    ).copyWith(primary: dynamicPrimary, secondary: dynamicSecondary);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: scheme, useMaterial3: true),
        home: Scaffold(
          body: Column(
            children: [
              HomiGoButton(text: 'Continue', onPressed: () {}),
              const HomiGoElevatedIcon(icon: Icons.home_rounded),
              HomiGoSegmentedControl<int>(
                value: 0,
                items: const [
                  HomiGoSegmentItem(value: 0, label: 'One'),
                  HomiGoSegmentItem(value: 1, label: 'Two'),
                ],
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ),
    );

    final surfaces = tester.widgetList<HomiGoNativeSurface>(
      find.byType(HomiGoNativeSurface),
    );

    expect(
      surfaces.any((surface) => surface.backgroundColor == dynamicPrimary),
      isTrue,
    );

    final iconContainer = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(HomiGoElevatedIcon),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoration = iconContainer.decoration! as BoxDecoration;
    final gradient = decoration.gradient! as LinearGradient;

    expect(gradient.colors.last, dynamicPrimary);
    expect(gradient.colors.last, isNot(brandPrimary));
  });

  test('HomiGoTheme can wrap an external ColorScheme', () {
    final scheme = ColorScheme.fromSeed(
      seedColor: dynamicPrimary,
      brightness: Brightness.dark,
    ).copyWith(primary: dynamicPrimary, secondary: dynamicSecondary);

    final theme = HomiGoTheme.fromColorScheme(scheme);

    expect(theme.colorScheme.primary, dynamicPrimary);
    expect(theme.colorScheme.secondary, dynamicSecondary);
    expect(theme.brightness, Brightness.dark);
  });
}
