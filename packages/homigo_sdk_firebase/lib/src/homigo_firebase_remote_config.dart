import 'package:firebase_remote_config/firebase_remote_config.dart';

class HomiGoFirebaseRemoteConfig {
  final FirebaseRemoteConfig _remoteConfig;

  HomiGoFirebaseRemoteConfig({FirebaseRemoteConfig? remoteConfig})
    : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  Future<void> initialize({
    Duration fetchTimeout = const Duration(seconds: 10),
    Duration minimumFetchInterval = const Duration(hours: 1),
    Map<String, Object> defaults = const {},
  }) async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval: minimumFetchInterval,
      ),
    );

    if (defaults.isNotEmpty) {
      await _remoteConfig.setDefaults(defaults);
    }
  }

  Future<bool> fetchAndActivate() {
    return _remoteConfig.fetchAndActivate();
  }

  String getString(String key) {
    return _remoteConfig.getString(key);
  }

  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  int getInt(String key) {
    return _remoteConfig.getInt(key);
  }

  double getDouble(String key) {
    return _remoteConfig.getDouble(key);
  }

  RemoteConfigValue getValue(String key) {
    return _remoteConfig.getValue(key);
  }
}
