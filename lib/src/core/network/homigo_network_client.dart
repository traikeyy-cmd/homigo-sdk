import 'dart:async';
import 'dart:convert';

import '../logger/homigo_logger.dart';
import 'homigo_api_models.dart';

enum HomiGoHttpMethod { get, post, put, patch, delete }

class HomiGoNetworkRequest {
  final HomiGoHttpMethod method;

  final Uri uri;

  final Map<String, String> headers;

  final Object? body;

  final Duration timeout;

  const HomiGoNetworkRequest({
    required this.method,
    required this.uri,
    this.headers = const {},
    this.body,
    this.timeout = const Duration(seconds: 30),
  });
}

class HomiGoNetworkRawResponse {
  final int statusCode;

  final String body;

  final Map<String, String> headers;

  const HomiGoNetworkRawResponse({
    required this.statusCode,
    required this.body,
    this.headers = const {},
  });
}

abstract interface class HomiGoNetworkTransport {
  Future<HomiGoNetworkRawResponse> send(HomiGoNetworkRequest request);
}

typedef HomiGoResponseDecoder<T> = T Function(Object? decoded);

typedef HomiGoTokenProvider = Future<String?> Function();

class HomiGoNetworkClient {
  final String baseUrl;

  final HomiGoNetworkTransport transport;

  final Map<String, String> defaultHeaders;

  final HomiGoTokenProvider? tokenProvider;

  final bool enableLogs;

  const HomiGoNetworkClient({
    required this.baseUrl,
    required this.transport,
    this.defaultHeaders = const {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    this.tokenProvider,
    this.enableLogs = false,
  });

  Future<HomiGoApiResponse<T>> request<T>({
    required String path,
    HomiGoHttpMethod method = HomiGoHttpMethod.get,
    Map<String, String> queryParameters = const {},
    Map<String, String> headers = const {},
    Object? body,
    HomiGoResponseDecoder<T>? decoder,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final uri = _buildUri(path, queryParameters);

    final requestHeaders = {...defaultHeaders, ...headers};

    final token = await tokenProvider?.call();

    if (token != null && token.isNotEmpty) {
      requestHeaders.putIfAbsent('Authorization', () => 'Bearer $token');
    }

    final request = HomiGoNetworkRequest(
      method: method,
      uri: uri,
      headers: requestHeaders,
      body: body,
      timeout: timeout,
    );

    if (enableLogs) {
      HomiGoLogger.debug(
        '${method.name.toUpperCase()} $uri',
        tag: 'HomiGoNetwork',
      );
    }

    HomiGoNetworkRawResponse raw;

    try {
      raw = await transport.send(request).timeout(timeout);
    } on TimeoutException catch (error, stackTrace) {
      HomiGoLogger.error(
        'Network request timed out',
        tag: 'HomiGoNetwork',
        error: error,
        stackTrace: stackTrace,
      );

      throw HomiGoApiException(
        message: 'Network request timed out',
        type: HomiGoApiErrorType.timeout,
        cause: error,
      );
    } on HomiGoApiException {
      rethrow;
    } catch (error, stackTrace) {
      HomiGoLogger.error(
        'Network request failed',
        tag: 'HomiGoNetwork',
        error: error,
        stackTrace: stackTrace,
      );

      throw HomiGoApiException(
        message: 'Network request failed',
        type: HomiGoApiErrorType.network,
        cause: error,
      );
    }

    if (enableLogs) {
      HomiGoLogger.debug('HTTP ${raw.statusCode} $uri', tag: 'HomiGoNetwork');
    }

    if (raw.statusCode < 200 || raw.statusCode >= 300) {
      throw _exceptionFromResponse(raw);
    }

    Object? decoded;

    if (raw.body.isNotEmpty) {
      try {
        decoded = jsonDecode(raw.body);
      } catch (_) {
        decoded = raw.body;
      }
    }

    final data = decoder == null ? decoded as T? : decoder(decoded);

    return HomiGoApiResponse<T>(
      statusCode: raw.statusCode,
      data: data,
      headers: raw.headers,
      rawBody: raw.body,
    );
  }

  Future<HomiGoApiResponse<T>> get<T>(
    String path, {
    Map<String, String> queryParameters = const {},
    Map<String, String> headers = const {},
    HomiGoResponseDecoder<T>? decoder,
  }) {
    return request<T>(
      path: path,
      method: HomiGoHttpMethod.get,
      queryParameters: queryParameters,
      headers: headers,
      decoder: decoder,
    );
  }

  Future<HomiGoApiResponse<T>> post<T>(
    String path, {
    Object? body,
    Map<String, String> headers = const {},
    HomiGoResponseDecoder<T>? decoder,
  }) {
    return request<T>(
      path: path,
      method: HomiGoHttpMethod.post,
      body: body,
      headers: headers,
      decoder: decoder,
    );
  }

  Uri _buildUri(String path, Map<String, String> queryParameters) {
    final normalizedBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    final normalizedPath = path.startsWith('/') ? path : '/$path';

    return Uri.parse('$normalizedBase$normalizedPath').replace(
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
  }

  HomiGoApiException _exceptionFromResponse(HomiGoNetworkRawResponse response) {
    final type = switch (response.statusCode) {
      401 => HomiGoApiErrorType.unauthorized,
      403 => HomiGoApiErrorType.forbidden,
      404 => HomiGoApiErrorType.notFound,
      400 || 422 => HomiGoApiErrorType.validation,
      >= 500 => HomiGoApiErrorType.server,
      _ => HomiGoApiErrorType.unknown,
    };

    return HomiGoApiException(
      message: 'Request failed with status ${response.statusCode}',
      type: type,
      statusCode: response.statusCode,
      details: {'body': response.body},
    );
  }
}
