import 'package:dio/dio.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/course.dart';
import '../models/course_model.dart';

class CourseRemoteDataSource {
  CourseRemoteDataSource(this._dio);
  final Dio _dio;

  Future<Result<List<Course>>> list({
    String? languageId,
    String? levelCode,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/courses',
        queryParameters: {
          if (languageId != null) 'languageId': languageId,
          if (levelCode != null) 'levelCode': levelCode,
          'page': page,
          'limit': limit,
        },
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final list = (response.data?['data'] as List?) ?? const [];
      final courses = list
          .whereType<Map>()
          .map(
            (m) => CourseModel.fromApi(Map<String, dynamic>.from(m)).toEntity(),
          )
          .toList(growable: false);
      return success(courses);
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<Course>> getById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/courses/$id');
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(
        CourseModel.fromApi(Map<String, dynamic>.from(data)).toEntity(),
      );
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  AppFailure _failureOf(Response<dynamic> r) {
    final body = ApiErrorBody.tryParse(r.data);
    final status = r.statusCode ?? 0;
    return ServerFailure(body?.message ?? 'Erreur ($status)', status);
  }

  AppFailure _map(DioException e) {
    final m = e.error;
    if (m is AppFailure) return m;
    return const NetworkFailure();
  }
}
