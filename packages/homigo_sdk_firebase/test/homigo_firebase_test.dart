import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk_firebase/homigo_sdk_firebase.dart';

void main() {
  test('firebase config has production-safe defaults', () {
    const config = HomiGoFirebaseConfig();

    expect(config.enableCrashlytics, isTrue);

    expect(config.initializeRemoteConfig, isTrue);

    expect(config.remoteConfigFetchTimeout, const Duration(seconds: 10));
  });
}
