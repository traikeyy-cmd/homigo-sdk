enum HomiGoAppEnvironment { development, staging, production }

class HomiGoEnvironmentConfig {
  final HomiGoAppEnvironment environment;

  final String? apiBaseUrl;

  final bool enableLogs;
  final bool enableNetworkLogs;

  final Map<String, Object?> values;

  const HomiGoEnvironmentConfig({
    this.environment = HomiGoAppEnvironment.production,
    this.apiBaseUrl,
    this.enableLogs = false,
    this.enableNetworkLogs = false,
    this.values = const {},
  });

  bool get isDevelopment => environment == HomiGoAppEnvironment.development;

  bool get isStaging => environment == HomiGoAppEnvironment.staging;

  bool get isProduction => environment == HomiGoAppEnvironment.production;

  T? value<T>(String key) {
    final result = values[key];

    if (result is T) {
      return result;
    }

    return null;
  }
}
