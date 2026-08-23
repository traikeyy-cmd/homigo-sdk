import 'dart:developer' as developer;

enum HomiGoLogLevel { debug, info, warning, error }

typedef HomiGoLogHandler = void Function(HomiGoLogEntry entry);

class HomiGoLogEntry {
  final HomiGoLogLevel level;
  final String message;
  final String? tag;
  final Object? error;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  HomiGoLogEntry({
    required this.level,
    required this.message,
    this.tag,
    this.error,
    this.stackTrace,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

abstract final class HomiGoLogger {
  static bool enabled = true;

  static HomiGoLogLevel minimumLevel = HomiGoLogLevel.debug;

  static HomiGoLogHandler? handler;

  static void debug(String message, {String? tag}) {
    _write(HomiGoLogLevel.debug, message, tag: tag);
  }

  static void info(String message, {String? tag}) {
    _write(HomiGoLogLevel.info, message, tag: tag);
  }

  static void warning(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _write(
      HomiGoLogLevel.warning,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _write(
      HomiGoLogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void _write(
    HomiGoLogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!enabled) {
      return;
    }

    if (level.index < minimumLevel.index) {
      return;
    }

    final entry = HomiGoLogEntry(
      level: level,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );

    if (handler != null) {
      handler!(entry);
      return;
    }

    developer.log(
      message,
      name: tag ?? 'HomiGoSDK',
      level: _developerLevel(level),
      error: error,
      stackTrace: stackTrace,
      time: entry.timestamp,
    );
  }

  static int _developerLevel(HomiGoLogLevel level) {
    return switch (level) {
      HomiGoLogLevel.debug => 500,
      HomiGoLogLevel.info => 800,
      HomiGoLogLevel.warning => 900,
      HomiGoLogLevel.error => 1000,
    };
  }
}
