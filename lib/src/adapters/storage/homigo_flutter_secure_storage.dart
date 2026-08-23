import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/storage/homigo_storage.dart';

class HomiGoFlutterSecureStorage implements HomiGoSecureStorage {
  final FlutterSecureStorage _storage;

  const HomiGoFlutterSecureStorage({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _storage = storage;

  @override
  Future<void> write(String key, Object? value) async {
    if (value == null) {
      await remove(key);
      return;
    }

    await _storage.write(key: key, value: jsonEncode(value));
  }

  @override
  Future<T?> read<T>(String key) async {
    final raw = await _storage.read(key: key);

    if (raw == null) {
      return null;
    }

    final decoded = jsonDecode(raw);

    if (decoded is T) {
      return decoded;
    }

    return null;
  }

  @override
  Future<bool> contains(String key) async {
    return _storage.containsKey(key: key);
  }

  @override
  Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> clear() async {
    await _storage.deleteAll();
  }

  @override
  Future<Set<String>> keys() async {
    final values = await _storage.readAll();
    return values.keys.toSet();
  }
}
