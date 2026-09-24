/// Environnements d'exécution et URLs d'API associées.
enum AppEnv { dev, staging, prod }

class AppConfig {
  const AppConfig._();

  /// Modifier via `--dart-define=APP_ENV=staging` au build.
  static const String _rawEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const String _apiDev = String.fromEnvironment(
    'API_DEV_URL',
    defaultValue: 'http://10.0.2.2:4000/api/v1',
  );

  static const String _apiStaging = String.fromEnvironment(
    'API_STAGING_URL',
    defaultValue: 'https://staging.api.langapp.example.com/api/v1',
  );

  static const String _apiProd = String.fromEnvironment(
    'API_PROD_URL',
    defaultValue: 'https://api.langapp.example.com/api/v1',
  );

  static AppEnv get environment {
    switch (_rawEnv) {
      case 'staging':
        return AppEnv.staging;
      case 'prod':
        return AppEnv.prod;
      default:
        return AppEnv.dev;
    }
  }

  static bool get isDev => environment == AppEnv.dev;

  static String get apiBaseUrl {
    switch (environment) {
      case AppEnv.dev:
        return _apiDev;
      case AppEnv.staging:
        return _apiStaging;
      case AppEnv.prod:
        return _apiProd;
    }
  }

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
