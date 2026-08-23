import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

class _FakeTransport implements HomiGoNetworkTransport {
  @override
  Future<HomiGoNetworkRawResponse> send(HomiGoNetworkRequest request) async {
    return const HomiGoNetworkRawResponse(
      statusCode: 200,
      body: '{"name":"HomiGo"}',
    );
  }
}

void main() {
  group('HomiGoNetworkClient', () {
    test('decodes successful JSON response', () async {
      final client = HomiGoNetworkClient(
        baseUrl: 'https://example.com',
        transport: _FakeTransport(),
      );

      final response = await client.get<Map<String, dynamic>>(
        '/test',
        decoder: (decoded) {
          return Map<String, dynamic>.from(decoded as Map);
        },
      );

      expect(response.isSuccess, isTrue);

      expect(response.data?['name'], 'HomiGo');
    });
  });
}
