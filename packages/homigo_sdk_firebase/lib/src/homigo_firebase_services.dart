import 'homigo_firebase_analytics.dart';
import 'homigo_firebase_auth.dart';
import 'homigo_firebase_core.dart';
import 'homigo_firebase_crashlytics.dart';
import 'homigo_firebase_messaging.dart';
import 'homigo_firebase_remote_config.dart';

abstract final class HomiGoFirebaseServices {
  static final core = HomiGoFirebaseCore();

  static final auth = HomiGoFirebaseAuth();

  static final messaging = HomiGoFirebaseMessaging();

  static final analytics = HomiGoFirebaseAnalytics();

  static final crashlytics = HomiGoFirebaseCrashlytics();

  static final remoteConfig = HomiGoFirebaseRemoteConfig();
}
