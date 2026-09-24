import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../utils/logger.dart';

/// Logs requêtes/réponses uniquement en debug — silencieux en release.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode) return handler.next(options);
    AppLogger.d(
      '→ ${options.method} ${options.uri}'
      '${options.data != null ? '\n  body: ${_short(options.data)}' : ''}',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (!kDebugMode) return handler.next(response);
    AppLogger.d(
      '← ${response.statusCode} ${response.requestOptions.uri}'
      '${response.data != null ? '\n  body: ${_short(response.data)}' : ''}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kDebugMode) return handler.next(err);
    AppLogger.w(
      '✗ ${err.response?.statusCode ?? '-'} '
      '${err.requestOptions.method} ${err.requestOptions.uri}\n'
      '  type: ${err.type}'
      '${err.response?.data != null ? '\n  body: ${_short(err.response!.data)}' : ''}',
    );
    handler.next(err);
  }

  String _short(Object? obj, {int max = 400}) {
    final s = obj.toString();
    return s.length <= max ? s : '${s.substring(0, max)}…';
  }
}
