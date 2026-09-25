import 'package:dio/dio.dart';
import 'package:langapp/core/errors/app_failure.dart';
import 'package:langapp/core/network/api_envelope.dart';
import 'package:langapp/core/utils/result.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_profile_model.dart';

/// Datasource remote — encapsule toutes les interactions HTTP du module auth.
///
/// Note importante : `dioProvider` est configuré avec
/// `validateStatus: (s) => s != null && s < 500`,
/// donc Dio **ne lance pas** d'exception pour les 4xx. Chaque méthode vérifie
/// le statut HTTP et renvoie un `Result` approprié.
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);
  final Dio _dio;

  // ─────────────────────────────────────────────────────────
  // Register
  // ─────────────────────────────────────────────────────────
  Future<Result<AuthResult>> register(RegisterParams params) async {
    return _postAuth(
      '/auth/register',
      data: {
        'firstName': params.firstName,
        'lastName': params.lastName,
        'email': params.email,
        'password': params.password,
        if (params.nativeLanguageId != null)
          'nativeLanguageId': params.nativeLanguageId,
        if (params.learningLanguageId != null)
          'learningLanguageId': params.learningLanguageId,
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  // Login
  // ─────────────────────────────────────────────────────────
  Future<Result<AuthResult>> login({
    required String email,
    required String password,
  }) async {
    return _postAuth(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
  }

  // ─────────────────────────────────────────────────────────
  // Refresh
  // ─────────────────────────────────────────────────────────
  Future<Result<AuthTokens>> refresh(String refreshToken) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final status = response.statusCode ?? 0;
      if (status >= 400) {
        return failure(_failureFromResponse(response));
      }

      final data = response.data?['data'];
      final tokensJson = data is Map ? data['tokens'] : null;
      if (tokensJson is! Map) {
        return failure(const ServerFailure('Réponse invalide'));
      }

      final model = AuthTokensModel.fromJson(
        Map<String, dynamic>.from(tokensJson),
      );
      return success(model.toEntity());
    } on DioException catch (e) {
      return failure(_mapDioException(e));
    }
  }

  // ─────────────────────────────────────────────────────────
  // Logout
  // ─────────────────────────────────────────────────────────
  Future<Result<void>> logout(String refreshToken) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/logout',
        data: {'refreshToken': refreshToken},
      );
      final status = response.statusCode ?? 0;
      if (status >= 400 && status != 401) {
        return failure(_failureFromResponse(response));
      }
      return success(null);
    } on DioException catch (e) {
      // Logout idempotent : on ignore les erreurs réseau — la purge locale
      // reste la source de vérité.
      final mapped = _mapDioException(e);
      if (mapped is NetworkFailure) return success(null);
      return failure(mapped);
    }
  }

  // ─────────────────────────────────────────────────────────
  // Forgot password
  // ─────────────────────────────────────────────────────────
  Future<Result<void>> forgotPassword(String email) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/forgot-password',
        data: {'email': email},
      );
      final status = response.statusCode ?? 0;
      if (status >= 400) return failure(_failureFromResponse(response));
      return success(null);
    } on DioException catch (e) {
      return failure(_mapDioException(e));
    }
  }

  // ─────────────────────────────────────────────────────────
  // Reset password
  // ─────────────────────────────────────────────────────────
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/reset-password',
        data: {'token': token, 'newPassword': newPassword},
      );
      final status = response.statusCode ?? 0;
      if (status >= 400) return failure(_failureFromResponse(response));
      return success(null);
    } on DioException catch (e) {
      return failure(_mapDioException(e));
    }
  }

  // ─────────────────────────────────────────────────────────
  // Verify email
  // ─────────────────────────────────────────────────────────
  Future<Result<void>> verifyEmail(String token) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/verify-email',
        data: {'token': token},
      );
      final status = response.statusCode ?? 0;
      if (status >= 400) return failure(_failureFromResponse(response));
      return success(null);
    } on DioException catch (e) {
      return failure(_mapDioException(e));
    }
  }

  // ─────────────────────────────────────────────────────────
  // Get me
  // ─────────────────────────────────────────────────────────
  Future<Result<UserProfile>> getMe() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/users/me');
      final status = response.statusCode ?? 0;
      if (status >= 400) return failure(_failureFromResponse(response));

      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));

      return success(
        UserProfileModel.fromJson(Map<String, dynamic>.from(data)).toEntity(),
      );
    } on DioException catch (e) {
      return failure(_mapDioException(e));
    }
  }

  // ─────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────
  Future<Result<AuthResult>> _postAuth(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: data);
      final status = response.statusCode ?? 0;
      if (status >= 400) return failure(_failureFromResponse(response));

      final body = response.data;
      if (body == null) return failure(const ServerFailure('Réponse vide'));

      final dataNode = body['data'];
      if (dataNode is! Map) {
        return failure(const ServerFailure('Réponse invalide'));
      }

      final userJson = dataNode['user'];
      final tokensJson = dataNode['tokens'];
      if (userJson is! Map || tokensJson is! Map) {
        return failure(const ServerFailure('Réponse incomplète'));
      }

      return success(
        AuthResult(
          user: UserProfileModel.fromJson(
            Map<String, dynamic>.from(userJson),
          ).toEntity(),
          tokens: AuthTokensModel.fromJson(
            Map<String, dynamic>.from(tokensJson),
          ).toEntity(),
        ),
      );
    } on DioException catch (e) {
      return failure(_mapDioException(e));
    }
  }

  AppFailure _failureFromResponse(Response<dynamic> response) {
    final body = ApiErrorBody.tryParse(response.data);
    final status = response.statusCode ?? 0;
    final message = body?.message ?? 'Erreur ($status)';
    final details = body?.details;

    if (status == 401) return UnauthorizedFailure(message);
    if (status == 404) return NotFoundFailure(message);
    if (status == 422 || status == 400) {
      return ValidationFailure(
        message,
        details is Map<String, dynamic> ? details : null,
      );
    }
    if (status >= 500) return ServerFailure(message, status);
    return ServerFailure(message, status);
  }

  AppFailure _mapDioException(DioException e) {
    final mapped = e.error;
    if (mapped is AppFailure) return mapped;
    return const NetworkFailure();
  }
}
