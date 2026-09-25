import 'package:dio/dio.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/result.dart';
import '../../../auth/data/models/user_profile_model.dart';
import '../../../auth/domain/entities/user_profile.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._dio);
  final Dio _dio;

  Future<Result<UserProfile>> getMe() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/users/me');
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(
        UserProfileModel.fromJson(Map<String, dynamic>.from(data)).toEntity(),
      );
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<UserProfile>> updateMe({
    String? firstName,
    String? lastName,
    String? nativeLanguageId,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/users/me',
        data: {
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          if (nativeLanguageId != null) 'nativeLanguageId': nativeLanguageId,
        },
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(
        UserProfileModel.fromJson(Map<String, dynamic>.from(data)).toEntity(),
      );
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/users/me/change-password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      return success(null);
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<void>> deleteAccount(String password) async {
    try {
      final response = await _dio.delete<dynamic>(
        '/users/me',
        data: {'password': password},
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      return success(null);
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  AppFailure _failureOf(Response<dynamic> r) {
    final body = ApiErrorBody.tryParse(r.data);
    final status = r.statusCode ?? 0;
    if (status == 401) {
      return UnauthorizedFailure(body?.message ?? 'Non autorisé');
    }
    if (status == 422 || status == 400) {
      return ValidationFailure(
        body?.message ?? 'Données invalides',
        body?.details is Map
            ? Map<String, dynamic>.from(body?.details as Map)
            : null,
      );
    }
    return ServerFailure(body?.message ?? 'Erreur ($status)', status);
  }

  AppFailure _map(DioException e) {
    final m = e.error;
    if (m is AppFailure) return m;
    return const NetworkFailure();
  }
}
