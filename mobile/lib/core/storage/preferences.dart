import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// Préférences non sensibles : langue de l'UI, thème, état d'onboarding,
/// curseur de synchronisation, etc.
class AppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static Future<AppPreferences> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppPreferences(prefs);
  }

  SharedPreferences get raw => _prefs;

  // ─── Locale ──────────────────────────────────────────────
  String? get localeCode => _prefs.getString(AppConstants.kLocaleKey);
  Future<void> setLocaleCode(String code) =>
      _prefs.setString(AppConstants.kLocaleKey, code);

  // ─── Thème ───────────────────────────────────────────────
  String get themeMode =>
      _prefs.getString(AppConstants.kThemeModeKey) ?? 'system';
  Future<void> setThemeMode(String mode) =>
      _prefs.setString(AppConstants.kThemeModeKey, mode);

  // ─── Onboarding ──────────────────────────────────────────
  bool get isOnboardingDone =>
      _prefs.getBool(AppConstants.kOnboardingDoneKey) ?? false;
  Future<void> setOnboardingDone(bool value) =>
      _prefs.setBool(AppConstants.kOnboardingDoneKey, value);

  // ─── Curseur de synchronisation ──────────────────────────
  String? get lastSyncAt => _prefs.getString(AppConstants.kLastSyncAtKey);
  Future<void> setLastSyncAt(String iso) =>
      _prefs.setString(AppConstants.kLastSyncAtKey, iso);

  // ─── Reset complet ───────────────────────────────────────
  Future<void> clear() => _prefs.clear();
}
