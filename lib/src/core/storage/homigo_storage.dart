abstract interface class HomiGoStorage {
  Future<void> write(String key, Object? value);

  Future<T?> read<T>(String key);

  Future<bool> contains(String key);

  Future<void> remove(String key);

  Future<void> clear();

  Future<Set<String>> keys();
}

abstract interface class HomiGoSecureStorage implements HomiGoStorage {}

class HomiGoMemoryStorage implements HomiGoStorage {
  final Map<String, Object?> _values = {};

  @override
  Future<void> write(String key, Object? value) async {
    _values[key] = value;
  }

  @override
  Future<T?> read<T>(String key) async {
    final value = _values[key];

    if (value is T) {
      return value;
    }

    return null;
  }

  @override
  Future<bool> contains(String key) async {
    return _values.containsKey(key);
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> clear() async {
    _values.clear();
  }

  @override
  Future<Set<String>> keys() async {
    return _values.keys.toSet();
  }
}

class HomiGoMemorySecureStorage extends HomiGoMemoryStorage
    implements HomiGoSecureStorage {}
