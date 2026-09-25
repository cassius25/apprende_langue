import 'package:dio/dio.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/streak.dart';

class StreakRemoteDataSource {
  StreakRemoteDataSource(this._dio);
  final Dio _dio;

  Future<Result<StreakInfo>> get() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/streak');
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(StreakInfo.fromJson(Map<String, dynamic>.from(data)));
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<StreakCalendar>> calendar({
    int days = 30,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/streak/calendar',
        queryParameters: {'days': days, 'offset': offset},
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(StreakCalendar.fromJson(Map<String, dynamic>.from(data)));
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
