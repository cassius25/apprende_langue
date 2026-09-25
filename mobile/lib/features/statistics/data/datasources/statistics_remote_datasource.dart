import 'package:dio/dio.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/statistics.dart';

class StatisticsRemoteDataSource {
  StatisticsRemoteDataSource(this._dio);
  final Dio _dio;

  Future<Result<OverviewStats>> overview() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/statistics');
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(OverviewStats.fromJson(Map<String, dynamic>.from(data)));
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<ActivityChart>> activity({
    int days = 30,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/statistics/activity',
        queryParameters: {'days': days, 'offset': offset},
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(ActivityChart.fromJson(Map<String, dynamic>.from(data)));
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<List<SkillProgress>>> skills({String? languageId}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/statistics/skills',
        queryParameters: {if (languageId != null) 'languageId': languageId},
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      final list = (data['skills'] as List?) ?? const [];
      return success(
        list
            .whereType<Map>()
            .map((m) => SkillProgress.fromJson(Map<String, dynamic>.from(m)))
            .toList(growable: false),
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
