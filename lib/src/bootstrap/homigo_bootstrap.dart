import 'package:flutter/widgets.dart';

import '../adapters/homigo_platform_adapters.dart';
import '../core/config/homigo_config.dart';
import '../core/config/homigo_sdk_core.dart';
import '../core/config/homigo_services.dart';
import '../core/lifecycle/homigo_app_lifecycle.dart';
import '../core/logger/homigo_logger.dart';
import '../core/network/homigo_network_client.dart';
import '../core/reliability/homigo_network_resilience.dart';
import '../core/reliability/homigo_retry.dart';
import '../platform/system_ui/homigo_system_ui.dart';

typedef HomiGoBootstrapHook = Future<void> Function();

class HomiGoBootstrapConfig {
  final HomiGoConfig sdkConfig;

  final bool enableSystemUI;

  final bool initializePlatformAdapters;

  final String? apiBaseUrl;

  final HomiGoNetworkTransport? transport;

  final Map<String, String> defaultHeaders;

  final HomiGoTokenProvider? tokenProvider;

  final HomiGoTokenRefreshCoordinator? tokenRefreshCoordinator;

  final HomiGoRetryPolicy retryPolicy;

  final HomiGoTimeoutPolicy timeoutPolicy;

  final List<HomiGoNetworkInterceptor> networkInterceptors;

  final bool requireOnlineBeforeRequest;

  final bool? enableLogs;

  final bool? enableNetworkLogs;

  final HomiGoBootstrapHook? afterCoreInitialize;

  const HomiGoBootstrapConfig({
    required this.sdkConfig,
    this.enableSystemUI = true,
    this.initializePlatformAdapters = true,
    this.apiBaseUrl,
    this.transport,
    this.defaultHeaders = const {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    this.tokenProvider,
    this.tokenRefreshCoordinator,
    this.retryPolicy = const HomiGoRetryPolicy(),
    this.timeoutPolicy = const HomiGoTimeoutPolicy(),
    this.networkInterceptors = const [],
    this.requireOnlineBeforeRequest = true,
    this.enableLogs,
    this.enableNetworkLogs,
    this.afterCoreInitialize,
  });
}

class HomiGoBootstrapState {
  final HomiGoPlatformAdapters? platformAdapters;

  final HomiGoResilientNetworkClient? network;

  const HomiGoBootstrapState({this.platformAdapters, this.network});
}

abstract final class HomiGoBootstrap {
  static HomiGoBootstrapState? _state;

  static bool get isInitialized => _state != null;

  static HomiGoBootstrapState get state {
    final current = _state;

    if (current == null) {
      throw StateError('HomiGoBootstrap has not been initialized.');
    }

    return current;
  }

  static Future<HomiGoBootstrapState> initialize({
    required HomiGoBootstrapConfig config,
  }) async {
    final current = _state;

    if (current != null) {
      return current;
    }

    WidgetsFlutterBinding.ensureInitialized();

    HomiGoPlatformAdapters? adapters;

    try {
      if (config.enableSystemUI) {
        await HomiGoSystemUI.initialize();
      }

      await HomiGoSDK.initialize(config: config.sdkConfig);

      final defaultLogs =
          config.sdkConfig.environment != HomiGoEnvironment.production;

      HomiGoLogger.enabled = config.enableLogs ?? defaultLogs;

      if (config.initializePlatformAdapters) {
        adapters = await HomiGoPlatformAdapters.initialize();
      }

      HomiGoResilientNetworkClient? network;

      final baseUrl = config.apiBaseUrl;

      if (baseUrl != null && baseUrl.isNotEmpty) {
        final transport = config.transport ?? adapters?.httpTransport;

        if (transport == null) {
          throw StateError(
            'A network transport is required when apiBaseUrl is configured.',
          );
        }

        HomiGoOfflineGuard? offlineGuard;

        final connectivity = HomiGoServices.connectivity;

        if (config.requireOnlineBeforeRequest && connectivity != null) {
          offlineGuard = HomiGoOfflineGuard(connectivity: connectivity);
        }

        network = HomiGoResilientNetworkClient(
          baseUrl: baseUrl,
          transport: transport,
          defaultHeaders: config.defaultHeaders,
          tokenProvider: config.tokenProvider,
          enableLogs: config.enableNetworkLogs ?? defaultLogs,
          retryPolicy: config.retryPolicy,
          timeoutPolicy: config.timeoutPolicy,
          offlineGuard: offlineGuard,
          tokenRefreshCoordinator: config.tokenRefreshCoordinator,
          interceptors: config.networkInterceptors,
        );

        HomiGoServices.network = network;
      }

      HomiGoAppLifecycle.instance.start();

      await config.afterCoreInitialize?.call();

      final result = HomiGoBootstrapState(
        platformAdapters: adapters,
        network: network,
      );

      _state = result;

      return result;
    } catch (_) {
      adapters?.httpTransport.close();

      HomiGoAppLifecycle.instance.stop();

      HomiGoServices.reset();
      HomiGoSDK.reset();

      rethrow;
    }
  }

  static void reset() {
    _state?.platformAdapters?.httpTransport.close();

    HomiGoAppLifecycle.instance.stop();

    HomiGoServices.reset();
    HomiGoSDK.reset();

    _state = null;
  }
}
