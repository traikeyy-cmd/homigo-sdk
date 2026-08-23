import 'package:shared_preferences/shared_preferences.dart';

import '../../core/storage/homigo_storage.dart';

class HomiGoSharedPreferencesStorage implements HomiGoStorage {
  final SharedPreferencesAsync _preferences;

  HomiGoSharedPreferencesStorage({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  @override
  Future<void> write(String key, Object? value) async {
    if (value == null) {
      await remove(key);
      return;
    }

    switch (value) {
      case String value:
        await _preferences.setString(key, value);

      case bool value:
        await _preferences.setBool(key, value);

      case int value:
        await _preferences.setInt(key, value);

      case double value:
        await _preferences.setDouble(key, value);

      case List<String> value:
        await _preferences.setStringList(key, value);

      default:
        throw ArgumentError(
          'Unsupported SharedPreferences value type: ${value.runtimeType}',
        );
    }
  }

  @override
  Future<T?> read<T>(String key) async {
    Object? value;

    if (T == String) {
      value = await _preferences.getString(key);
    } else if (T == bool) {
      value = await _preferences.getBool(key);
    } else if (T == int) {
      value = await _preferences.getInt(key);
    } else if (T == double) {
      value = await _preferences.getDouble(key);
    } else if (T == List<String>) {
      value = await _preferences.getStringList(key);
    } else {
      return null;
    }

    if (value is T) {
      return value;
    }

    return null;
  }

  @override
  Future<bool> contains(String key) async {
    final keys = await _preferences.getKeys();
    return keys.contains(key);
  }

  @override
  Future<void> remove(String key) async {
    await _preferences.remove(key);
  }

  @override
  Future<void> clear() async {
    await _preferences.clear();
  }

  @override
  Future<Set<String>> keys() async {
    return _preferences.getKeys();
  }
}
