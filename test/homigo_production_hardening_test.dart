import 'package:flutter_test/flutter_test.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

class _FlakyTransport implements HomiGoNetworkTransport {
  int calls = 0;

  @override
  Future<HomiGoNetworkRawResponse> send(HomiGoNetworkRequest request) async {
    calls++;

    if (calls < 3) {
      return const HomiGoNetworkRawResponse(
        statusCode: 500,
        body: '{"error":"temporary"}',
      );
    }

    return const HomiGoNetworkRawResponse(
      statusCode: 200,
      body: '{"name":"HomiGo"}',
    );
  }
}

class _UnauthorizedOnceTransport implements HomiGoNetworkTransport {
  int calls = 0;

  @override
  Future<HomiGoNetworkRawResponse> send(HomiGoNetworkRequest request) async {
    calls++;

    if (calls == 1) {
      return const HomiGoNetworkRawResponse(
        statusCode: 401,
        body: '{"error":"unauthorized"}',
      );
    }

    return const HomiGoNetworkRawResponse(statusCode: 200, body: '{"ok":true}');
  }
}

void main() {
  group('HomiGoResult', () {
    test('supports success and failure', () {
      final success = HomiGoResult<int>.success(10);

      expect(success.isSuccess, isTrue);

      expect(success.dataOrNull, 10);

      final failure = HomiGoResult<int>.failure(
        const HomiGoFailure(code: 'test', message: 'Failed'),
      );

      expect(failure.isFailure, isTrue);

      expect(failure.failureOrNull?.code, 'test');
    });
  });

  group('HomiGoCancellationToken', () {
    test('throws after cancellation', () {
      final token = HomiGoCancellationToken();

      token.cancel('user_cancelled');

      expect(token.throwIfCancelled, throwsA(isA<HomiGoCancelledException>()));
    });
  });

  group('HomiGo resilient network', () {
    test('retries server failures', () async {
      final transport = _FlakyTransport();

      final client = HomiGoResilientNetworkClient(
        baseUrl: 'https://example.com',
        transport: transport,
        retryPolicy: const HomiGoRetryPolicy(
          maxAttempts: 3,
          backoff: HomiGoExponentialBackoff(
            initialDelay: Duration.zero,
            maximumDelay: Duration.zero,
          ),
        ),
      );

      final response = await client.get<Map<String, dynamic>>(
        '/test',
        decoder: (decoded) => Map<String, dynamic>.from(decoded as Map),
      );

      expect(transport.calls, 3);

      expect(response.data?['name'], 'HomiGo');
    });

    test('refreshes token after unauthorized response', () async {
      final transport = _UnauthorizedOnceTransport();

      var refreshCalls = 0;

      final coordinator = HomiGoTokenRefreshCoordinator(
        refreshHandler: () async {
          refreshCalls++;
        },
      );

      final client = HomiGoResilientNetworkClient(
        baseUrl: 'https://example.com',
        transport: transport,
        tokenRefreshCoordinator: coordinator,
        retryPolicy: const HomiGoRetryPolicy(maxAttempts: 1),
      );

      final response = await client.get<Map<String, dynamic>>(
        '/secure',
        decoder: (decoded) => Map<String, dynamic>.from(decoded as Map),
      );

      expect(refreshCalls, 1);

      expect(transport.calls, 2);

      expect(response.data?['ok'], isTrue);
    });
  });

  group('HomiGoErrorMapper', () {
    test('maps server errors as retryable', () {
      const exception = HomiGoApiException(
        message: 'Server failed',
        type: HomiGoApiErrorType.server,
        statusCode: 500,
      );

      final failure = HomiGoErrorMapper.map(exception);

      expect(failure.retryable, isTrue);

      expect(failure.statusCode, 500);
    });
  });
}
