import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

/// Stockage sécurisé : tokens JWT + identifiant utilisateur.
/// Utilise Keychain (iOS) / EncryptedSharedPreferences (Android).
class SecureTokenStorage {
  SecureTokenStorage({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  final FlutterSecureStorage _storage;

  // ─── Tokens ──────────────────────────────────────────────
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? refreshExpiresAt,
  }) async {
    await Future.wait([
      _storage.write(key: AppConstants.kAccessTokenKey, value: accessToken),
      _storage.write(key: AppConstants.kRefreshTokenKey, value: refreshToken),
      if (refreshExpiresAt != null)
        _storage.write(
          key: '${AppConstants.kRefreshTokenKey}.expiresAt',
          value: refreshExpiresAt,
        ),
    ]);
  }

  Future<String?> readAccessToken() =>
      _storage.read(key: AppConstants.kAccessTokenKey);

  Future<String?> readRefreshToken() =>
      _storage.read(key: AppConstants.kRefreshTokenKey);

  Future<String?> readRefreshExpiresAt() =>
      _storage.read(key: '${AppConstants.kRefreshTokenKey}.expiresAt');

  // ─── Utilisateur ─────────────────────────────────────────
  Future<void> saveUserId(String userId) =>
      _storage.write(key: AppConstants.kUserIdKey, value: userId);

  Future<String?> readUserId() => _storage.read(key: AppConstants.kUserIdKey);

  // ─── Nettoyage ───────────────────────────────────────────
  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: AppConstants.kAccessTokenKey),
      _storage.delete(key: AppConstants.kRefreshTokenKey),
      _storage.delete(key: '${AppConstants.kRefreshTokenKey}.expiresAt'),
      _storage.delete(key: AppConstants.kUserIdKey),
    ]);
  }
}
