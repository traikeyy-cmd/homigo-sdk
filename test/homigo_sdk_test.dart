import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  setUp(() {
    HomiGoSDK.reset();
  });

  tearDown(() {
    HomiGoSDK.reset();
  });

  group('HomiGoSDK', () {
    test('is not initialized by default', () {
      expect(HomiGoSDK.isInitialized, isFalse);
    });

    test('throws StateError when config is accessed before initialization', () {
      expect(() => HomiGoSDK.config, throwsA(isA<StateError>()));
    });

    test('initializes with the supplied configuration', () async {
      const config = HomiGoConfig(
        appName: 'HomiGo SDK Test',
        environment: HomiGoEnvironment.development,
        themeMode: ThemeMode.system,
      );

      await HomiGoSDK.initialize(config: config);

      expect(HomiGoSDK.isInitialized, isTrue);
      expect(HomiGoSDK.config.appName, 'HomiGo SDK Test');
      expect(HomiGoSDK.config.environment, HomiGoEnvironment.development);
      expect(HomiGoSDK.config.themeMode, ThemeMode.system);
    });

    test('uses default brand configuration', () async {
      const config = HomiGoConfig(appName: 'HomiGo SDK Test');

      await HomiGoSDK.initialize(config: config);

      expect(HomiGoSDK.config.brand.primaryColor, HomiGoColors.primary);

      expect(HomiGoSDK.config.brand.secondaryColor, HomiGoColors.secondary);

      expect(HomiGoSDK.config.brand.useGlassEffect, isTrue);
    });

    test('uses Arabic as the default locale', () async {
      const config = HomiGoConfig(appName: 'HomiGo SDK Test');

      await HomiGoSDK.initialize(config: config);

      expect(HomiGoSDK.config.defaultLocale, const Locale('ar'));

      expect(HomiGoSDK.config.supportedLocales, contains(const Locale('ar')));

      expect(HomiGoSDK.config.supportedLocales, contains(const Locale('en')));
    });

    test('reset clears SDK configuration', () async {
      const config = HomiGoConfig(appName: 'HomiGo SDK Test');

      await HomiGoSDK.initialize(config: config);

      expect(HomiGoSDK.isInitialized, isTrue);

      HomiGoSDK.reset();

      expect(HomiGoSDK.isInitialized, isFalse);
    });
  });
}
