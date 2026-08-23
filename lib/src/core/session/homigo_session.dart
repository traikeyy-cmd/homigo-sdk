import '../storage/homigo_storage.dart';

class HomiGoSessionData {
  final String? userId;
  final String? accessToken;
  final String? refreshToken;

  final Map<String, Object?> metadata;

  const HomiGoSessionData({
    this.userId,
    this.accessToken,
    this.refreshToken,
    this.metadata = const {},
  });

  bool get isAuthenticated => accessToken != null && accessToken!.isNotEmpty;

  HomiGoSessionData copyWith({
    String? userId,
    String? accessToken,
    String? refreshToken,
    Map<String, Object?>? metadata,
  }) {
    return HomiGoSessionData(
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      metadata: metadata ?? this.metadata,
    );
  }
}

class HomiGoSession {
  static const String _userIdKey = 'homigo.session.user_id';

  static const String _accessTokenKey = 'homigo.session.access_token';

  static const String _refreshTokenKey = 'homigo.session.refresh_token';

  final HomiGoSecureStorage storage;

  HomiGoSession({required this.storage});

  Future<HomiGoSessionData> load() async {
    return HomiGoSessionData(
      userId: await storage.read<String>(_userIdKey),
      accessToken: await storage.read<String>(_accessTokenKey),
      refreshToken: await storage.read<String>(_refreshTokenKey),
    );
  }

  Future<void> save(HomiGoSessionData session) async {
    await storage.write(_userIdKey, session.userId);

    await storage.write(_accessTokenKey, session.accessToken);

    await storage.write(_refreshTokenKey, session.refreshToken);
  }

  Future<bool> get isAuthenticated async {
    final session = await load();

    return session.isAuthenticated;
  }

  Future<void> clear() async {
    await storage.remove(_userIdKey);

    await storage.remove(_accessTokenKey);

    await storage.remove(_refreshTokenKey);
  }
}
