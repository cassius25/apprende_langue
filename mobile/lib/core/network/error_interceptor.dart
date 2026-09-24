import 'package:dio/dio.dart';

import '../errors/app_failure.dart';
import 'api_envelope.dart';
import 'api_exception.dart';

/// Convertit une `DioException` en `AppFailure` (jamais levée à l'extérieur).
/// Les repositories reçoivent directement un `AppFailure` typé.
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = mapDioErrorToFailure(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: failure,
        stackTrace: err.stackTrace,
      ),
    );
  }
}

/// Mappe `DioException` → `AppFailure` avec lecture de l'enveloppe d'erreur API.
AppFailure mapDioErrorToFailure(DioException err) {
  final statusCode = err.response?.statusCode;

  // Erreurs réseau bas niveau
  switch (err.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const NetworkFailure('Délai de connexion dépassé');
    case DioExceptionType.connectionError:
      return const NetworkFailure('Impossible de joindre le serveur');
    case DioExceptionType.cancel:
      return const UnknownFailure('Requête annulée');
    case DioExceptionType.badCertificate:
      return const NetworkFailure('Certificat invalide');
    case DioExceptionType.unknown:
      if (err.error is AppFailure) return err.error as AppFailure;
      return const UnknownFailure();
    case DioExceptionType.badResponse:
      break;
    case DioExceptionType.transformTimeout:
      break;
  }

  // Erreurs HTTP avec corps typé
  final body = ApiErrorBody.tryParse(err.response?.data);

  if (statusCode == 401) {
    return UnauthorizedFailure(body?.message ?? 'Non autorisé');
  }
  if (statusCode == 403) {
    return ServerFailure(body?.message ?? 'Accès refusé', 403);
  }
  if (statusCode == 404) {
    return NotFoundFailure(body?.message ?? 'Ressource introuvable');
  }
  if (statusCode == 409) {
    return ServerFailure(body?.message ?? 'Conflit', 409);
  }
  if (statusCode == 422 || statusCode == 400) {
    return ValidationFailure(
      body?.message ?? 'Données invalides',
      body?.details is Map<String, dynamic>
          ? body!.details as Map<String, dynamic>
          : null,
    );
  }
  if (statusCode == 429) {
    return ServerFailure(body?.message ?? 'Trop de requêtes', 429);
  }
  if (statusCode != null && statusCode >= 500) {
    return ServerFailure(body?.message ?? 'Erreur serveur', statusCode);
  }

  // Erreur inconnue avec réponse
  if (body != null) {
    return ServerFailure(body.message, statusCode);
  }
  if (err.error is ApiException) {
    final api = err.error as ApiException;
    return ServerFailure(api.message, api.statusCode);
  }
  return const UnknownFailure();
}
