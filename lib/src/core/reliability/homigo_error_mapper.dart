import 'dart:async';

import '../network/homigo_api_models.dart';
import '../result/homigo_result.dart';
import 'homigo_cancellation.dart';
import 'homigo_network_resilience.dart';

abstract final class HomiGoErrorMapper {
  static HomiGoFailure map(Object error) {
    if (error is HomiGoCancelledException) {
      return HomiGoFailure(
        code: 'cancelled',
        message: error.reason ?? 'Operation cancelled.',
        retryable: false,
        cause: error,
      );
    }

    if (error is HomiGoOfflineException) {
      return HomiGoFailure(
        code: 'offline',
        message: error.message,
        retryable: true,
        cause: error,
      );
    }

    if (error is TimeoutException) {
      return HomiGoFailure(
        code: 'timeout',
        message: 'The operation timed out.',
        retryable: true,
        cause: error,
      );
    }

    if (error is HomiGoApiException) {
      final retryable = switch (error.type) {
        HomiGoApiErrorType.network => true,
        HomiGoApiErrorType.timeout => true,
        HomiGoApiErrorType.server => true,
        _ => false,
      };

      return HomiGoFailure(
        code: error.type.name,
        message: error.message,
        retryable: retryable,
        statusCode: error.statusCode,
        cause: error.cause ?? error,
      );
    }

    return HomiGoFailure(
      code: 'unknown',
      message: 'An unexpected error occurred.',
      retryable: false,
      cause: error,
    );
  }

  static Future<HomiGoResult<T>> guard<T>(Future<T> Function() action) async {
    try {
      final result = await action();

      return HomiGoResult<T>.success(result);
    } catch (error) {
      return HomiGoResult<T>.failure(map(error));
    }
  }
}
