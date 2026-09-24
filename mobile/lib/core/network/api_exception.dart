import 'api_envelope.dart';

/// Exception réseau « brute » levée par les repositories avant mapping.
/// Préserve les informations du backend (`ApiErrorBody`) pour un mapping riche.
class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.message,
    this.code,
    this.details,
  });

  final int? statusCode;
  final String message;
  final String? code;
  final dynamic details;

  factory ApiException.fromErrorBody(int? statusCode, ApiErrorBody body) {
    return ApiException(
      statusCode: statusCode,
      message: body.message,
      code: body.code,
      details: body.details,
    );
  }

  @override
  String toString() => 'ApiException($statusCode, $code): $message';
}
