import 'dart:async';

import 'package:dio/dio.dart';

import '../config/app_env.dart';
import '../storage/secure_storage.dart';
import '../utils/logger.dart';

/// Callback déclenché quand le refresh échoue (tokens purgés).
/// Le container Riverpod le câblera sur le feature Auth pour rediriger vers /login.
typedef OnSessionExpired = void Function();

/// Intercepteur JWT :
/// - injecte `Authorization: Bearer <accessToken>` sur chaque requête protégée
/// - si 401 → tente un `POST /auth/refresh`
/// - **sérialise** les refresh concurrents (une seule requête en vol)
/// - si refresh échoue → purge les tokens et notifie via `onSessionExpired`
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this._dio,
    required this._tokenStorage,
    required this._onSessionExpired,
  });

  final Dio _dio; // Dio « brut » (sans ce interceptor) pour le refresh
  final SecureTokenStorage _tokenStorage;
  final OnSessionExpired _onSessionExpired;

  /// Empêche les refresh concurrents.
  Future<String?>? _refreshInFlight;

  static const String _authHeader = 'Authorization';
  static const String _retryFlag = '_retried';

  /// Routes qui ne doivent **jamais** recevoir l'en-tête Authorization.
  static const Set<String> _publicPaths = {
    '/auth/register',
    '/auth/login',
    '/auth/refresh',
    '/auth/forgot-password',
    '/auth/reset-password',
    '/auth/verify-email',
  };

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isPublic(options.path)) {
      final token = await _tokenStorage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers[_authHeader] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final options = err.requestOptions;

    // Conditions d'échec immédiat
    if (status != 401) return handler.next(err);
    if (_isPublic(options.path)) return handler.next(err);
    if (options.extra[_retryFlag] == true) return handler.next(err);

    final newAccess = await _refreshAccessToken();
    if (newAccess == null) {
      await _tokenStorage.clear();
      _onSessionExpired();
      return handler.next(err);
    }

    // Rejoue la requête avec le nouveau token
    options.extra[_retryFlag] = true;
    options.headers[_authHeader] = 'Bearer $newAccess';

    try {
      final response = await _dio.fetch<dynamic>(options);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  // ─────────────────────────────────────────────────────────
  // Refresh sérialisé
  // ─────────────────────────────────────────────────────────
  Future<String?> _refreshAccessToken() {
    // Une seule requête de refresh en vol
    return _refreshInFlight ??= _doRefresh().whenComplete(() {
      _refreshInFlight = null;
    });
  }

  Future<String?> _doRefresh() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      AppLogger.w('Refresh: aucun refresh token disponible');
      return null;
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '${AppConfig.apiBaseUrl}/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(
          extra: {'_skipAuth': true},
          // Empêche une récursion infinie
          validateStatus: (s) => s != null && s < 500,
        ),
      );

      if (response.statusCode != 200) {
        AppLogger.w('Refresh échoué: status=${response.statusCode}');
        return null;
      }

      final body = response.data;
      final data = body?['data'];
      final tokens = data is Map<String, dynamic> ? data['tokens'] : null;
      if (tokens is! Map<String, dynamic>) return null;

      final newAccess = tokens['accessToken'] as String?;
      final newRefresh = tokens['refreshToken'] as String?;
      final refreshExpiresAt = tokens['refreshTokenExpiresAt'] as String?;

      if (newAccess == null || newRefresh == null) return null;

      await _tokenStorage.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
        refreshExpiresAt: refreshExpiresAt,
      );
      AppLogger.i('Tokens rafraîchis');
      return newAccess;
    } catch (e, st) {
      AppLogger.e('Erreur refresh', error: e, stack: st);
      return null;
    }
  }

  bool _isPublic(String path) {
    // Ignore la base URL, ne garde que le chemin relatif
    final normalized = path.startsWith('/') ? path : '/$path';
    return _publicPaths.any((p) => normalized.contains(p));
  }
}
