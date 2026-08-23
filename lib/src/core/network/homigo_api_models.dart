enum HomiGoApiErrorType {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validation,
  server,
  cancelled,
  unknown,
}

class HomiGoApiException implements Exception {
  final String message;

  final HomiGoApiErrorType type;

  final int? statusCode;

  final Object? cause;

  final Map<String, Object?>? details;

  const HomiGoApiException({
    required this.message,
    this.type = HomiGoApiErrorType.unknown,
    this.statusCode,
    this.cause,
    this.details,
  });

  @override
  String toString() {
    return 'HomiGoApiException('
        'type: $type, '
        'statusCode: $statusCode, '
        'message: $message'
        ')';
  }
}

class HomiGoApiResponse<T> {
  final T? data;

  final int statusCode;

  final Map<String, String> headers;

  final String? rawBody;

  const HomiGoApiResponse({
    required this.statusCode,
    this.data,
    this.headers = const {},
    this.rawBody,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
