import 'dart:async';
import 'dart:math' as math;

import '../network/homigo_api_models.dart';
import 'homigo_cancellation.dart';

typedef HomiGoRetryPredicate = bool Function(Object error, int attempt);

abstract interface class HomiGoBackoffStrategy {
  Duration delayForRetry(int retryNumber);
}

class HomiGoExponentialBackoff implements HomiGoBackoffStrategy {
  final Duration initialDelay;

  final Duration maximumDelay;

  final double multiplier;

  const HomiGoExponentialBackoff({
    this.initialDelay = const Duration(milliseconds: 400),
    this.maximumDelay = const Duration(seconds: 8),
    this.multiplier = 2,
  });

  @override
  Duration delayForRetry(int retryNumber) {
    if (retryNumber <= 0) {
      return Duration.zero;
    }

    final calculated =
        initialDelay.inMilliseconds * math.pow(multiplier, retryNumber - 1);

    final milliseconds = math.min(
      calculated.round(),
      maximumDelay.inMilliseconds,
    );

    return Duration(milliseconds: milliseconds);
  }
}

class HomiGoRetryPolicy {
  final int maxAttempts;

  final HomiGoBackoffStrategy backoff;

  final HomiGoRetryPredicate? retryPredicate;

  const HomiGoRetryPolicy({
    this.maxAttempts = 3,
    this.backoff = const HomiGoExponentialBackoff(),
    this.retryPredicate,
  }) : assert(maxAttempts >= 1);

  bool shouldRetry(Object error, int attempt) {
    if (attempt >= maxAttempts) {
      return false;
    }

    final custom = retryPredicate;

    if (custom != null) {
      return custom(error, attempt);
    }

    if (error is HomiGoApiException) {
      return switch (error.type) {
        HomiGoApiErrorType.network => true,
        HomiGoApiErrorType.timeout => true,
        HomiGoApiErrorType.server => true,
        _ => false,
      };
    }

    if (error is TimeoutException) {
      return true;
    }

    return false;
  }

  Duration delayForRetry(int failedAttempt) {
    return backoff.delayForRetry(failedAttempt);
  }

  Future<void> waitBeforeRetry(
    int failedAttempt, {
    HomiGoCancellationToken? cancellationToken,
  }) async {
    final delay = delayForRetry(failedAttempt);

    if (delay == Duration.zero) {
      cancellationToken?.throwIfCancelled();
      return;
    }

    if (cancellationToken == null) {
      await Future<void>.delayed(delay);

      return;
    }

    await Future.any<void>([
      Future<void>.delayed(delay),
      cancellationToken.whenCancelled.then<void>((_) {
        cancellationToken.throwIfCancelled();
      }),
    ]);

    cancellationToken.throwIfCancelled();
  }
}
