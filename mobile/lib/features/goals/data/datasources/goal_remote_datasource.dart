import 'package:dio/dio.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/daily_goal.dart';
import '../../domain/repositories/goal_repository.dart';

class GoalRemoteDataSource {
  GoalRemoteDataSource(this._dio);
  final Dio _dio;

  Future<Result<List<DailyGoal>>> list() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/goals');
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final list = (response.data?['data'] as List?) ?? const [];
      return success(
        list
            .whereType<Map>()
            .map((m) => _fromApi(Map<String, dynamic>.from(m)))
            .toList(growable: false),
      );
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<TodayGoal>> today() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/goals/today');
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(TodayGoal.fromJson(Map<String, dynamic>.from(data)));
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<DailyGoal>> upsert({
    required GoalType type,
    required int target,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/goals',
        data: {'type': goalTypeToApi(type), 'target': target},
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(_fromApi(Map<String, dynamic>.from(data)));
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<DailyGoal>> update(
    String id, {
    int? target,
    bool? isActive,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/goals/$id',
        data: {
          if (target != null) 'target': target,
          if (isActive != null) 'isActive': isActive,
        },
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      return success(_fromApi(Map<String, dynamic>.from(data)));
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<void>> remove(String id) async {
    try {
      final response = await _dio.delete<dynamic>('/goals/$id');
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      return success(null);
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  DailyGoal _fromApi(Map<String, dynamic> json) => DailyGoal(
    id: json['id'] as String,
    type: goalTypeFromString(json['type'] as String? ?? 'MINUTES'),
    target: (json['target'] as num?)?.toInt() ?? 0,
    isActive: json['isActive'] as bool? ?? true,
  );

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
