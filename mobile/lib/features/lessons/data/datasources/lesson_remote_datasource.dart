import 'package:dio/dio.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../models/lesson_model.dart';

class LessonRemoteDataSource {
  LessonRemoteDataSource(this._dio);
  final Dio _dio;

  Future<Result<Lesson>> getById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/lessons/$id');
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(
        LessonModel.fromApi(Map<String, dynamic>.from(data)).toEntity(),
      );
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<LessonCompletion>> complete(
    String id, {
    int? score,
    int? timeSpentSec,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/lessons/$id/complete',
        data: {
          if (score != null) 'score': score,
          if (timeSpentSec != null) 'timeSpentSec': timeSpentSec,
        },
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      final model = LessonCompletionModel(
        json: Map<String, dynamic>.from(data),
      );
      return success(
        LessonCompletion(
          xpEarned: model.xpEarned,
          totalXp: model.totalXp,
          userLevel: model.userLevel,
          progress: model.progress,
        ),
      );
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  AppFailure _failureOf(Response<dynamic> r) {
    final body = ApiErrorBody.tryParse(r.data);
    final status = r.statusCode ?? 0;
    if (status == 404) return NotFoundFailure(body?.message ?? 'Introuvable');
    if (status == 401) {
      return UnauthorizedFailure(body?.message ?? 'Non autorisé');
    }
    return ServerFailure(body?.message ?? 'Erreur ($status)', status);
  }

  AppFailure _map(DioException e) {
    final m = e.error;
    if (m is AppFailure) return m;
    return const NetworkFailure();
  }
}
