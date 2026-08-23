import 'dart:async';

import 'package:flutter/widgets.dart';

class HomiGoAppLifecycle with WidgetsBindingObserver {
  HomiGoAppLifecycle._();

  static final HomiGoAppLifecycle instance = HomiGoAppLifecycle._();

  final StreamController<AppLifecycleState> _controller =
      StreamController<AppLifecycleState>.broadcast();

  bool _started = false;

  AppLifecycleState? _currentState;

  bool get isStarted => _started;

  AppLifecycleState? get currentState => _currentState;

  Stream<AppLifecycleState> get changes => _controller.stream;

  void start() {
    if (_started) {
      return;
    }

    _started = true;

    WidgetsBinding.instance.addObserver(this);

    _currentState = WidgetsBinding.instance.lifecycleState;
  }

  void stop() {
    if (!_started) {
      return;
    }

    WidgetsBinding.instance.removeObserver(this);

    _started = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _currentState = state;

    _controller.add(state);
  }
}
