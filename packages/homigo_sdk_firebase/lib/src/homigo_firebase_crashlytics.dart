import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class HomiGoFirebaseCrashlytics {
  final FirebaseCrashlytics _crashlytics;

  HomiGoFirebaseCrashlytics({FirebaseCrashlytics? crashlytics})
    : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  Future<void> initialize({
    bool fatalFlutterErrors = true,
    bool fatalPlatformErrors = true,
  }) async {
    if (fatalFlutterErrors) {
      FlutterError.onError = _crashlytics.recordFlutterFatalError;
    }

    if (fatalPlatformErrors) {
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics.recordError(error, stack, fatal: true);

        return true;
      };
    }
  }

  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
    String? reason,
  }) {
    return _crashlytics.recordError(
      error,
      stackTrace,
      fatal: fatal,
      reason: reason,
    );
  }

  Future<void> log(String message) {
    return _crashlytics.log(message);
  }

  Future<void> setUserIdentifier(String identifier) {
    return _crashlytics.setUserIdentifier(identifier);
  }

  Future<void> setCustomKey(String key, Object value) {
    return _crashlytics.setCustomKey(key, value);
  }

  Future<void> setEnabled(bool enabled) {
    return _crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }
}
