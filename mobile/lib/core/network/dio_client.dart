import 'package:dio/dio.dart';

import '../config/app_env.dart';
import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'logging_interceptor.dart';

/// Factory Dio :
/// - baseUrl configurable par environnement
/// - délais courts (mobile)
/// - ordre des intercepteurs : Logging → Auth → Error
/// - le Dio renvoyé ici est celui utilisé par les repositories (avec Auth)
///
/// Un **Dio "refresh"** séparé (sans AuthInterceptor) est utilisé en interne
/// par AuthInterceptor pour éviter les récursions.
class DioClient {
  const DioClient._();

  static Dio build({
    required SecureTokenStorage tokenStorage,
    required OnSessionExpired onSessionExpired,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
        headers: {'Accept': 'application/json'},
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Dio « brut » utilisé par AuthInterceptor pour /auth/refresh.
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      LoggingInterceptor(),
      AuthInterceptor(
        dio: refreshDio,
        tokenStorage: tokenStorage,
        onSessionExpired: onSessionExpired,
      ),
      ErrorInterceptor(),
    ]);

    return dio;
  }
}
