import 'package:dio/dio.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_result.dart';
import '../models/correction_model.dart';
import '../models/exercise_model.dart';

class ExerciseRemoteDataSource {
  ExerciseRemoteDataSource(this._dio);
  final Dio _dio;

  /// Récupère les exercices depuis `GET /lessons/:id` (payload leçon complet).
  Future<Result<List<Exercise>>> listForLesson(String lessonId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/lessons/$lessonId',
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }

      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));

      final raw = data['exercises'];
      if (raw is! List) return success(const []);

      final exercises =
          raw
              .whereType<Map>()
              .map(
                (m) => ExerciseModel.fromApi(
                  Map<String, dynamic>.from(m),
                ).toEntity(lessonId: lessonId),
              )
              .toList(growable: false)
            ..sort((a, b) => a.order.compareTo(b.order));

      return success(exercises);
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<SubmitExerciseResult>> submit({
    required String exerciseId,
    required Map<String, dynamic> answer,
    int? responseTimeMs,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/exercises/$exerciseId/submit',
        data: {
          'answer': answer,
          if (responseTimeMs != null) 'responseTimeMs': responseTimeMs,
        },
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }

      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(
        CorrectionModel.fromApi(Map<String, dynamic>.from(data)).toEntity(),
      );
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
    if (status == 404) return NotFoundFailure(body?.message ?? 'Introuvable');
    if (status == 422 || status == 400) {
      return ValidationFailure(
        body?.message ?? 'Réponse invalide',
        (body?.details as Map?)?.cast<String, dynamic>(),
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
