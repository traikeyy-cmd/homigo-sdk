import 'dart:async';

class HomiGoCancelledException implements Exception {
  final String? reason;

  const HomiGoCancelledException([this.reason]);

  @override
  String toString() {
    if (reason == null || reason!.isEmpty) {
      return 'HomiGoCancelledException';
    }

    return 'HomiGoCancelledException: $reason';
  }
}

class HomiGoCancellationToken {
  bool _cancelled = false;

  String? _reason;

  final Completer<void> _completer = Completer<void>();

  bool get isCancelled => _cancelled;

  String? get reason => _reason;

  Future<void> get whenCancelled => _completer.future;

  void cancel([String? reason]) {
    if (_cancelled) {
      return;
    }

    _cancelled = true;
    _reason = reason;

    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }

  void throwIfCancelled() {
    if (!_cancelled) {
      return;
    }

    throw HomiGoCancelledException(_reason);
  }
}
