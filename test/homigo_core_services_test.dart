import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

void main() {
  group('HomiGoMemoryStorage', () {
    test('writes and reads values', () async {
      final storage = HomiGoMemoryStorage();

      await storage.write('name', 'HomiGo');

      expect(await storage.read<String>('name'), 'HomiGo');
    });

    test('removes values', () async {
      final storage = HomiGoMemoryStorage();

      await storage.write('key', 'value');

      await storage.remove('key');

      expect(await storage.contains('key'), isFalse);
    });
  });

  group('HomiGoSession', () {
    test('saves and restores session', () async {
      final storage = HomiGoMemorySecureStorage();

      final session = HomiGoSession(storage: storage);

      await session.save(
        const HomiGoSessionData(
          userId: '123',
          accessToken: 'token',
          refreshToken: 'refresh',
        ),
      );

      final restored = await session.load();

      expect(restored.userId, '123');

      expect(restored.accessToken, 'token');

      expect(restored.isAuthenticated, isTrue);
    });
  });

  group('HomiGoValidators', () {
    test('validates email', () {
      expect(HomiGoValidators.email('test@example.com'), isNull);

      expect(HomiGoValidators.email('invalid'), isNotNull);
    });
  });

  group('HomiGoFormatters', () {
    test('extracts digits', () {
      expect(HomiGoFormatters.digitsOnly('+966 50-123'), '96650123');
    });
  });
}
