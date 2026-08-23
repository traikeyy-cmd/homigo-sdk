import 'package:firebase_analytics/firebase_analytics.dart';

class HomiGoFirebaseAnalytics {
  final FirebaseAnalytics _analytics;

  HomiGoFirebaseAnalytics({FirebaseAnalytics? analytics})
    : _analytics = analytics ?? FirebaseAnalytics.instance;

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> setUserId(String? userId) {
    return _analytics.setUserId(id: userId);
  }

  Future<void> setUserProperty({required String name, required String? value}) {
    return _analytics.setUserProperty(name: name, value: value);
  }

  Future<void> logLogin({String? loginMethod}) {
    return _analytics.logLogin(loginMethod: loginMethod);
  }

  Future<void> logSignUp({required String signUpMethod}) {
    return _analytics.logSignUp(signUpMethod: signUpMethod);
  }
}
