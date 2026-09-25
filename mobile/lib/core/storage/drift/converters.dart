import 'dart:convert';

import 'package:drift/drift.dart';

/// Convertit un `Map<String, dynamic>` ↔ TEXT JSON.
/// Utilisé pour les payloads de `SyncQueueEntries.payloadJson` et
/// `LocalExercises.dataJson` (matching, word-order…).
class JsonMapConverter extends TypeConverter<Map<String, dynamic>?, String?> {
  const JsonMapConverter();

  @override
  Map<String, dynamic>? fromSql(String? fromDb) {
    if (fromDb == null || fromDb.isEmpty) return null;
    try {
      final decoded = jsonDecode(fromDb);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  String? toSql(Map<String, dynamic>? value) {
    if (value == null) return null;
    return jsonEncode(value);
  }
}
