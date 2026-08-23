import 'dart:async';

import '../connectivity/homigo_connectivity.dart';
import '../network/homigo_api_models.dart';
import '../network/homigo_network_client.dart';
import 'homigo_cancellation.dart';
import 'homigo_retry.dart';

class HomiGoTimeoutPolicy {
  final Duration readTimeout;
  final Duration writeTimeout;
  final Duration deleteTimeout;

  const HomiGoTimeoutPolicy({
    this.readTimeout = const Duration(seconds: 30),
    this.writeTimeout = const Duration(seconds: 45),
    this.deleteTimeout = const Duration(seconds: 30),
  });

  Duration timeoutFor(HomiGoHttpMethod method) {
    return switch (method) {
      HomiGoHttpMethod.get => readTimeout,
      HomiGoHttpMethod.post ||
      HomiGoHttpMethod.put ||
      HomiGoHttpMethod.patch => writeTimeout,
      HomiGoHttpMethod.delete => deleteTimeout,
    };
  }
}

class HomiGoOfflineException implements Exception {
  final String message;

  const HomiGoOfflineException([this.message = 'No network connection.']);

  @override
  String toString() => 'HomiGoOfflineException: $message';
}

class HomiGoOfflineGuard {
  final HomiGoConnectivity connectivity;

  const HomiGoOfflineGuard({required this.connectivity});

  Future<void> ensureOnline() async {
    final status = await connectivity.check();

    if (status == HomiGoConnectivityStatus.offline) {
      throw const HomiGoOfflineException();
    }
  }
}

typedef HomiGoTokenRefreshHandler = Future<void> Function();

class HomiGoTokenRefreshCoordinator {
  final HomiGoTokenRefreshHandler refreshHandler;

  Completer<void>? _activeRefresh;

  HomiGoTokenRefreshCoordinator({required this.refreshHandler});

  bool get isRefreshing => _activeRefresh != null;

  Future<void> refresh() {
    final current = _activeRefresh;

    if (current != null) {
      return current.future;
    }

    final completer = Completer<void>();

    _activeRefresh = completer;

    unawaited(_performRefresh(completer));

    return completer.future;
  }

  Future<void> _performRefresh(Completer<void> completer) async {
    try {
      await refreshHandler();

      if (!completer.isCompleted) {
        completer.complete();
      }
    } catch (error, stackTrace) {
      if (!completer.isCompleted) {
        completer.completeError(error, stackTrace);
      }
    } finally {
      if (identical(_activeRefresh, completer)) {
        _activeRefresh = null;
      }
    }
  }
}

class HomiGoNetworkContext {
  final String path;

  final HomiGoHttpMethod method;

  final Map<String, String> queryParameters;

  final Map<String, String> headers;

  final Object? body;

  final int attempt;

  const HomiGoNetworkContext({
    required this.path,
    required this.method,
    this.queryParameters = const {},
    this.headers = const {},
    this.body,
    this.attempt = 1,
  });

  HomiGoNetworkContext copyWith({
    String? path,
    HomiGoHttpMethod? method,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    Object? body,
    int? attempt,
  }) {
    return HomiGoNetworkContext(
      path: path ?? this.path,
      method: method ?? this.method,
      queryParameters: queryParameters ?? this.queryParameters,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      attempt: attempt ?? this.attempt,
    );
  }
}

abstract class HomiGoNetworkInterceptor {
  const HomiGoNetworkInterceptor();

  Future<HomiGoNetworkContext> onRequest(HomiGoNetworkContext context) async {
    return context;
  }

  Future<void> onResponse(HomiGoNetworkContext context, int statusCode) async {}

  Future<void> onError(
    HomiGoNetworkContext context,
    Object error,
    StackTrace stackTrace,
  ) async {}
}

class HomiGoHeaderInterceptor extends HomiGoNetworkInterceptor {
  final Map<String, String> headers;

  const HomiGoHeaderInterceptor(this.headers);

  @override
  Future<HomiGoNetworkContext> onRequest(HomiGoNetworkContext context) async {
    return context.copyWith(headers: {...context.headers, ...headers});
  }
}

class HomiGoResilientNetworkClient extends HomiGoNetworkClient {
  final HomiGoRetryPolicy retryPolicy;

  final HomiGoTimeoutPolicy timeoutPolicy;

  final HomiGoOfflineGuard? offlineGuard;

  final HomiGoTokenRefreshCoordinator? tokenRefreshCoordinator;

  final List<HomiGoNetworkInterceptor> interceptors;

  HomiGoResilientNetworkClient({
    required super.baseUrl,
    required super.transport,
    super.defaultHeaders = const {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    super.tokenProvider,
    super.enableLogs = false,
    this.retryPolicy = const HomiGoRetryPolicy(),
    this.timeoutPolicy = const HomiGoTimeoutPolicy(),
    this.offlineGuard,
    this.tokenRefreshCoordinator,
    this.interceptors = const [],
  });

  @override
  Future<HomiGoApiResponse<T>> request<T>({
    required String path,
    HomiGoHttpMethod method = HomiGoHttpMethod.get,
    Map<String, String> queryParameters = const {},
    Map<String, String> headers = const {},
    Object? body,
    HomiGoResponseDecoder<T>? decoder,
    Duration timeout = const Duration(seconds: 30),
  }) {
    return _requestInternal<T>(
      path: path,
      method: method,
      queryParameters: queryParameters,
      headers: headers,
      body: body,
      decoder: decoder,
      timeout: timeout,
    );
  }

  Future<HomiGoApiResponse<T>> requestWithControl<T>({
    required String path,
    HomiGoHttpMethod method = HomiGoHttpMethod.get,
    Map<String, String> queryParameters = const {},
    Map<String, String> headers = const {},
    Object? body,
    HomiGoResponseDecoder<T>? decoder,
    Duration timeout = const Duration(seconds: 30),
    HomiGoCancellationToken? cancellationToken,
  }) {
    return _requestInternal<T>(
      path: path,
      method: method,
      queryParameters: queryParameters,
      headers: headers,
      body: body,
      decoder: decoder,
      timeout: timeout,
      cancellationToken: cancellationToken,
    );
  }

  Future<HomiGoApiResponse<T>> _requestInternal<T>({
    required String path,
    required HomiGoHttpMethod method,
    required Map<String, String> queryParameters,
    required Map<String, String> headers,
    required Object? body,
    required HomiGoResponseDecoder<T>? decoder,
    required Duration timeout,
    HomiGoCancellationToken? cancellationToken,
  }) async {
    var attempt = 1;

    var refreshAttempted = false;

    final effectiveTimeout = timeout == const Duration(seconds: 30)
        ? timeoutPolicy.timeoutFor(method)
        : timeout;

    while (true) {
      cancellationToken?.throwIfCancelled();

      await offlineGuard?.ensureOnline();

      var context = HomiGoNetworkContext(
        path: path,
        method: method,
        queryParameters: queryParameters,
        headers: headers,
        body: body,
        attempt: attempt,
      );

      try {
        for (final interceptor in interceptors) {
          context = await interceptor.onRequest(context);
        }

        cancellationToken?.throwIfCancelled();

        final response = await super.request<T>(
          path: context.path,
          method: context.method,
          queryParameters: context.queryParameters,
          headers: context.headers,
          body: context.body,
          decoder: decoder,
          timeout: effectiveTimeout,
        );

        cancellationToken?.throwIfCancelled();

        for (final interceptor in interceptors) {
          await interceptor.onResponse(context, response.statusCode);
        }

        return response;
      } catch (error, stackTrace) {
        for (final interceptor in interceptors) {
          await interceptor.onError(context, error, stackTrace);
        }

        cancellationToken?.throwIfCancelled();

        final unauthorized =
            error is HomiGoApiException &&
            error.type == HomiGoApiErrorType.unauthorized;

        if (unauthorized &&
            tokenRefreshCoordinator != null &&
            !refreshAttempted) {
          refreshAttempted = true;

          try {
            await tokenRefreshCoordinator!.refresh();

            continue;
          } catch (_) {
            Error.throwWithStackTrace(error, stackTrace);
          }
        }

        if (!retryPolicy.shouldRetry(error, attempt)) {
          Error.throwWithStackTrace(error, stackTrace);
        }

        await retryPolicy.waitBeforeRetry(
          attempt,
          cancellationToken: cancellationToken,
        );

        attempt++;
      }
    }
  }
}
