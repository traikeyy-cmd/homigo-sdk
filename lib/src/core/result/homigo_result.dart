class HomiGoFailure {
  final String code;
  final String message;
  final bool retryable;
  final int? statusCode;
  final Object? cause;

  const HomiGoFailure({
    required this.code,
    required this.message,
    this.retryable = false,
    this.statusCode,
    this.cause,
  });

  @override
  String toString() {
    return 'HomiGoFailure('
        'code: $code, '
        'message: $message, '
        'retryable: $retryable, '
        'statusCode: $statusCode'
        ')';
  }
}

sealed class HomiGoResult<T> {
  const HomiGoResult();

  factory HomiGoResult.success(T data) = HomiGoSuccess<T>;

  factory HomiGoResult.failure(HomiGoFailure failure) = HomiGoFailureResult<T>;

  bool get isSuccess;

  bool get isFailure => !isSuccess;

  T? get dataOrNull;

  HomiGoFailure? get failureOrNull;
}

final class HomiGoSuccess<T> extends HomiGoResult<T> {
  final T data;

  const HomiGoSuccess(this.data);

  @override
  bool get isSuccess => true;

  @override
  T get dataOrNull => data;

  @override
  HomiGoFailure? get failureOrNull => null;
}

final class HomiGoFailureResult<T> extends HomiGoResult<T> {
  final HomiGoFailure failure;

  const HomiGoFailureResult(this.failure);

  @override
  bool get isSuccess => false;

  @override
  T? get dataOrNull => null;

  @override
  HomiGoFailure get failureOrNull => failure;
}
