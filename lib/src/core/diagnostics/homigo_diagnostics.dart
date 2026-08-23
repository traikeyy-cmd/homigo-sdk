import '../config/homigo_sdk_core.dart';
import '../config/homigo_services.dart';
import '../connectivity/homigo_connectivity.dart';
import '../lifecycle/homigo_app_lifecycle.dart';

class HomiGoDiagnosticsSnapshot {
  final bool sdkInitialized;

  final String? appName;

  final String? environment;

  final String? lifecycleState;

  final Map<String, bool> services;

  const HomiGoDiagnosticsSnapshot({
    required this.sdkInitialized,
    required this.services,
    this.appName,
    this.environment,
    this.lifecycleState,
  });

  Map<String, Object?> toMap() {
    return {
      'sdkInitialized': sdkInitialized,
      'appName': appName,
      'environment': environment,
      'lifecycleState': lifecycleState,
      'services': services,
    };
  }
}

abstract final class HomiGoDiagnostics {
  static HomiGoDiagnosticsSnapshot snapshot() {
    final initialized = HomiGoSDK.isInitialized;

    return HomiGoDiagnosticsSnapshot(
      sdkInitialized: initialized,
      appName: initialized ? HomiGoSDK.config.appName : null,
      environment: initialized ? HomiGoSDK.config.environment.name : null,
      lifecycleState: HomiGoAppLifecycle.instance.currentState?.name,
      services: {
        'storage': HomiGoServices.storage != null,
        'secureStorage': HomiGoServices.secureStorage != null,
        'session': HomiGoServices.session != null,
        'network': HomiGoServices.network != null,
        'connectivity': HomiGoServices.connectivity != null,
        'permissions': HomiGoServices.permissions != null,
      },
    );
  }
}

enum HomiGoHealthStatus { healthy, degraded, unhealthy }

class HomiGoHealthCheckItem {
  final String name;

  final HomiGoHealthStatus status;

  final String message;

  const HomiGoHealthCheckItem({
    required this.name,
    required this.status,
    required this.message,
  });
}

class HomiGoHealthReport {
  final HomiGoHealthStatus status;

  final List<HomiGoHealthCheckItem> checks;

  const HomiGoHealthReport({required this.status, required this.checks});

  bool get isHealthy => status == HomiGoHealthStatus.healthy;
}

abstract final class HomiGoHealthCheck {
  static Future<HomiGoHealthReport> run({
    bool requireNetwork = false,
    bool checkConnectivity = true,
  }) async {
    final checks = <HomiGoHealthCheckItem>[];

    if (HomiGoSDK.isInitialized) {
      checks.add(
        const HomiGoHealthCheckItem(
          name: 'sdk',
          status: HomiGoHealthStatus.healthy,
          message: 'SDK initialized.',
        ),
      );
    } else {
      checks.add(
        const HomiGoHealthCheckItem(
          name: 'sdk',
          status: HomiGoHealthStatus.unhealthy,
          message: 'SDK is not initialized.',
        ),
      );
    }

    final network = HomiGoServices.network;

    if (network != null) {
      checks.add(
        const HomiGoHealthCheckItem(
          name: 'network',
          status: HomiGoHealthStatus.healthy,
          message: 'Network client registered.',
        ),
      );
    } else if (requireNetwork) {
      checks.add(
        const HomiGoHealthCheckItem(
          name: 'network',
          status: HomiGoHealthStatus.unhealthy,
          message: 'Network client is required but not registered.',
        ),
      );
    }

    if (checkConnectivity && HomiGoServices.connectivity != null) {
      try {
        final status = await HomiGoServices.connectivity!.check();

        checks.add(
          HomiGoHealthCheckItem(
            name: 'connectivity',
            status: switch (status) {
              HomiGoConnectivityStatus.online => HomiGoHealthStatus.healthy,
              HomiGoConnectivityStatus.offline => HomiGoHealthStatus.degraded,
              HomiGoConnectivityStatus.unknown => HomiGoHealthStatus.degraded,
            },
            message: 'Connectivity: ${status.name}.',
          ),
        );
      } catch (error) {
        checks.add(
          HomiGoHealthCheckItem(
            name: 'connectivity',
            status: HomiGoHealthStatus.degraded,
            message: 'Connectivity check failed: $error',
          ),
        );
      }
    }

    final hasUnhealthy = checks.any(
      (item) => item.status == HomiGoHealthStatus.unhealthy,
    );

    final hasDegraded = checks.any(
      (item) => item.status == HomiGoHealthStatus.degraded,
    );

    final overall = hasUnhealthy
        ? HomiGoHealthStatus.unhealthy
        : hasDegraded
        ? HomiGoHealthStatus.degraded
        : HomiGoHealthStatus.healthy;

    return HomiGoHealthReport(status: overall, checks: checks);
  }
}
