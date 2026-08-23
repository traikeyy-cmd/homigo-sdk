import 'package:firebase_core/firebase_core.dart';

import 'homigo_firebase_services.dart';

class HomiGoFirebaseConfig {
  final bool enableCrashlytics;

  final bool initializeRemoteConfig;

  final Duration remoteConfigFetchTimeout;
  final Duration remoteConfigMinimumFetchInterval;

  final Map<String, Object> remoteConfigDefaults;

  const HomiGoFirebaseConfig({
    this.enableCrashlytics = true,
    this.initializeRemoteConfig = true,
    this.remoteConfigFetchTimeout = const Duration(seconds: 10),
    this.remoteConfigMinimumFetchInterval = const Duration(hours: 1),
    this.remoteConfigDefaults = const {},
  });
}

abstract final class HomiGoFirebase {
  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<void> initialize({
    FirebaseOptions? options,
    HomiGoFirebaseConfig config = const HomiGoFirebaseConfig(),
  }) async {
    if (_initialized) {
      return;
    }

    await HomiGoFirebaseServices.core.initialize(options: options);

    if (config.enableCrashlytics) {
      await HomiGoFirebaseServices.crashlytics.initialize();
    }

    if (config.initializeRemoteConfig) {
      await HomiGoFirebaseServices.remoteConfig.initialize(
        fetchTimeout: config.remoteConfigFetchTimeout,
        minimumFetchInterval: config.remoteConfigMinimumFetchInterval,
        defaults: config.remoteConfigDefaults,
      );
    }

    _initialized = true;
  }
}
