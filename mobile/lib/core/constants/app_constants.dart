class AppConstants {
  const AppConstants._();

  // Branding
  static const String appName = 'LangApp';
  static const String supportEmail = 'support@langapp.example.com';

  // Stockage sécurisé (clés)
  static const String kAccessTokenKey = 'langapp.access_token';
  static const String kRefreshTokenKey = 'langapp.refresh_token';
  static const String kUserIdKey = 'langapp.user_id';
  static const String kLastSyncAtKey = 'langapp.last_sync_at';
  static const String kOnboardingDoneKey = 'langapp.onboarding_done';
  static const String kLocaleKey = 'langapp.locale';
  static const String kThemeModeKey = 'langapp.theme_mode';

  // Limites UI
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Durées
  static const Duration snackBarShort = Duration(seconds: 2);
  static const Duration snackBarLong = Duration(seconds: 4);
  static const Duration syncDebounce = Duration(seconds: 3);
  static const Duration syncRetryBase = Duration(seconds: 1);
  static const int syncMaxRetries = 5;
}
