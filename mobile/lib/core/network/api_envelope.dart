/// Enveloppe standard renvoyée par l'API :
/// `{ "success": true, "data": ..., "meta": {...} }`
class ApiEnvelope<T> {
  const ApiEnvelope({required this.success, this.data, this.meta});

  final bool success;
  final T? data;
  final Map<String, dynamic>? meta;

  static ApiEnvelope<T> fromJson<T>(
    Map<String, dynamic> json,
    T Function(Object? raw) decode,
  ) {
    return ApiEnvelope<T>(
      success: json['success'] == true,
      data: json.containsKey('data') ? decode(json['data']) : null,
      meta: json['meta'] is Map<String, dynamic>
          ? json['meta'] as Map<String, dynamic>
          : null,
    );
  }
}

/// Métadonnées de pagination renvoyées par le backend.
class PaginationMeta {
  const PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      hasNext: json['hasNext'] == true,
      hasPrev: json['hasPrev'] == true,
    );
  }

  static PaginationMeta? tryParse(Map<String, dynamic>? meta) {
    if (meta == null) return null;
    try {
      return PaginationMeta.fromJson(meta);
    } catch (_) {
      return null;
    }
  }
}

/// Erreur d'API renvoyée par le backend :
/// `{ "success": false, "error": { "code": ..., "message": ..., "details": ... } }`
class ApiErrorBody {
  const ApiErrorBody({required this.code, required this.message, this.details});

  final String code;
  final String message;
  final dynamic details;

  static ApiErrorBody? tryParse(Object? raw) {
    if (raw is! Map) return null;
    final error = raw['error'];
    if (error is! Map) return null;
    final code = error['code'];
    final message = error['message'];
    if (code is! String || message is! String) return null;
    return ApiErrorBody(
      code: code,
      message: message,
      details: error['details'],
    );
  }
}
