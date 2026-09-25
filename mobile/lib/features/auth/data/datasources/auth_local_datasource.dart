import 'package:drift/drift.dart';
import 'package:langapp/core/storage/drift/app_database.dart';
import 'package:langapp/core/storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user_profile.dart';

/// Persistance locale de la session :
/// - tokens → SecureStorage
/// - profil  → Drift (`local_user_profile`)
class AuthLocalDataSource {
  AuthLocalDataSource({
    required SecureTokenStorage secureStorage,
    required AppDatabase database,
  }) : _secure = secureStorage,
       _db = database;

  final SecureTokenStorage _secure;
  final AppDatabase _db;
  static const _uuid = Uuid();

  // ─────────────────────────────────────────────────────────
  // Tokens
  // ─────────────────────────────────────────────────────────
  Future<void> saveTokens(AuthTokens tokens) {
    return _secure.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      refreshExpiresAt: tokens.refreshTokenExpiresAt,
    );
  }

  Future<String?> readAccessToken() => _secure.readAccessToken();
  Future<String?> readRefreshToken() => _secure.readRefreshToken();

  Future<bool> hasTokens() async {
    final access = await _secure.readAccessToken();
    final refresh = await _secure.readRefreshToken();
    return (access?.isNotEmpty ?? false) && (refresh?.isNotEmpty ?? false);
  }

  // ─────────────────────────────────────────────────────────
  // Profile
  // ─────────────────────────────────────────────────────────
  Future<void> saveProfile(UserProfile user) async {
    final now = DateTime.now();
    await _db.userDao.upsertProfile(
      LocalUserProfileCompanion.insert(
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role.name.toUpperCase(),
        emailVerified: Value(user.emailVerified),
        nativeLanguageId: Value(user.nativeLanguageId),
        xp: Value(user.xp),
        userLevel: Value(user.userLevel),
        serverUpdatedAt: user.createdAt ?? now,
      ),
    );
    await _secure.saveUserId(user.id);
  }

  Future<UserProfile?> readProfile() async {
    final row = await _db.userDao.getProfile();
    if (row == null) return null;
    return _rowToEntity(row);
  }

  UserProfile _rowToEntity(LocalUserProfileData row) {
    return UserProfile(
      id: row.id,
      email: row.email,
      firstName: row.firstName,
      lastName: row.lastName,
      role: _parseRole(row.role),
      emailVerified: row.emailVerified,
      nativeLanguageId: row.nativeLanguageId,
      xp: row.xp,
      userLevel: row.userLevel,
      createdAt: row.serverUpdatedAt,
    );
  }

  UserRole _parseRole(String r) {
    switch (r) {
      case 'ADMIN':
        return UserRole.admin;
      case 'CONTENT_MANAGER':
        return UserRole.contentManager;
      default:
        return UserRole.user;
    }
  }

  // ─────────────────────────────────────────────────────────
  // Purge
  // ─────────────────────────────────────────────────────────
  Future<void> purgeSession() async {
    await _secure.clear();
    await _db.userDao.wipeUserData();
    await _db.syncQueueDao.wipe();
  }

  /// Petit utilitaire : génère un UUID v4 (réutilisable).
  static String newId() => _uuid.v4();
}
