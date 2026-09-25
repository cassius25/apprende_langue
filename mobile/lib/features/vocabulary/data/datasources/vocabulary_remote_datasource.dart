import 'package:dio/dio.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_vocabulary_entry.dart';
import '../../domain/entities/vocabulary_item.dart';
import '../models/user_vocabulary_model.dart';
import '../models/vocabulary_item_model.dart';

class VocabularyRemoteDataSource {
  VocabularyRemoteDataSource(this._dio);
  final Dio _dio;

  Future<Result<List<VocabularyItem>>> listCatalog({
    String? languageCode,
    String? levelCode,
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/vocabulary',
        queryParameters: {
          if (languageCode != null) 'languageCode': languageCode,
          if (levelCode != null) 'levelCode': levelCode,
          if (category != null) 'category': category,
          if (search != null && search.isNotEmpty) 'search': search,
          'page': page,
          'limit': limit,
        },
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final list = (response.data?['data'] as List?) ?? const [];
      final items = list
          .whereType<Map>()
          .map(
            (m) => VocabularyItemModel.fromApi(
              Map<String, dynamic>.from(m),
            ).toEntity(),
          )
          .toList(growable: false);
      return success(items);
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<VocabularyItem>> getById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/vocabulary/$id');
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(
        VocabularyItemModel.fromApi(Map<String, dynamic>.from(data)).toEntity(),
      );
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<List<UserVocabularyEntry>>> listMyWords({
    String? state,
    bool? isFavorite,
    String? languageCode,
    String? search,
    int page = 1,
    int limit = 200,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/vocabulary/me',
        queryParameters: {
          if (state != null) 'state': state,
          if (isFavorite != null) 'isFavorite': isFavorite.toString(),
          if (search != null && search.isNotEmpty) 'search': search,
          'page': page,
          'limit': limit,
        },
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final list = (response.data?['data'] as List?) ?? const [];
      final items = list
          .whereType<Map>()
          .map(
            (m) => UserVocabularyModel.fromApi(
              Map<String, dynamic>.from(m),
            ).toEntity(),
          )
          .toList(growable: false);
      // ignore: unused_local_variable
      final _ = languageCode;
      return success(items);
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<UserVocabularyEntry>> startLearning(String vocabularyId) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/vocabulary/me/learn',
        data: {'vocabularyId': vocabularyId},
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(
        UserVocabularyModel.fromApi(Map<String, dynamic>.from(data)).toEntity(),
      );
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<UserVocabularyEntry>> setFavorite(
    String vocabularyId,
    bool value,
  ) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/vocabulary/me/$vocabularyId/favorite',
        data: {'isFavorite': value},
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(
        UserVocabularyModel.fromApi(Map<String, dynamic>.from(data)).toEntity(),
      );
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<UserVocabularyEntry>> setState(
    String vocabularyId,
    String state,
  ) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/vocabulary/me/$vocabularyId/state',
        data: {'state': state},
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(
        UserVocabularyModel.fromApi(Map<String, dynamic>.from(data)).toEntity(),
      );
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  AppFailure _failureOf(Response<dynamic> r) {
    final body = ApiErrorBody.tryParse(r.data);
    final status = r.statusCode ?? 0;
    final msg = body?.message ?? 'Erreur ($status)';
    if (status == 401) return UnauthorizedFailure(msg);
    if (status == 404) return NotFoundFailure(msg);
    if (status >= 500) return ServerFailure(msg, status);
    return ServerFailure(msg, status);
  }

  AppFailure _map(DioException e) {
    final m = e.error;
    if (m is AppFailure) return m;
    return const NetworkFailure();
  }
}
