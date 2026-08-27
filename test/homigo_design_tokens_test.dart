import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  test('HomiGo motion tokens expose standard design timings', () {
    expect(HomiGoMotion.press, const Duration(milliseconds: 120));

    expect(HomiGoMotion.fast, const Duration(milliseconds: 150));

    expect(HomiGoMotion.standard, const Duration(milliseconds: 180));

    expect(HomiGoMotion.relaxed, const Duration(milliseconds: 220));

    expect(HomiGoMotion.pressedScale, 0.98);
    expect(HomiGoMotion.compactPressedScale, 0.975);
  });

  test('HomiGo elevation tokens expose native UI shadow values', () {
    expect(HomiGoElevation.cardBlur, 12);
    expect(HomiGoElevation.cardOffset.dy, 4);
    expect(HomiGoElevation.cardOpacityLight, 0.055);
    expect(HomiGoElevation.cardOpacityDark, 0.22);

    expect(HomiGoElevation.iconPrimaryBlur, 12);
    expect(HomiGoElevation.iconPrimaryOffset.dy, 6);
    expect(HomiGoElevation.iconPrimaryOpacity, 0.22);

    expect(HomiGoElevation.selectedBlur, 8);
    expect(HomiGoElevation.selectedOffset.dy, 2);
    expect(HomiGoElevation.selectedOpacity, 0.18);
  });
}
