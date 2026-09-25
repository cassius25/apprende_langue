import 'package:dio/dio.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/language.dart';
import '../models/language_model.dart';

class LanguageRemoteDataSource {
  LanguageRemoteDataSource(this._dio);
  final Dio _dio;

  Future<Result<List<Language>>> listAll() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/languages');
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final list = (response.data?['data'] as List?) ?? const [];
      final languages = list
          .whereType<Map>()
          .map(
            (m) =>
                LanguageModel.fromApi(Map<String, dynamic>.from(m)).toEntity(),
          )
          .toList(growable: false);
      return success(languages);
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
