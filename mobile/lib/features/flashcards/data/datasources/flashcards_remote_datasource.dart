import 'package:dio/dio.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/result.dart';
import '../../../vocabulary/data/models/user_vocabulary_model.dart';
import '../../../vocabulary/domain/entities/user_vocabulary_entry.dart';

class FlashcardsRemoteDataSource {
  FlashcardsRemoteDataSource(this._dio);
  final Dio _dio;

  /// POST /reviews — renvoie l'état SRS post-soumission.
  Future<Result<UserVocabularyEntry>> submitReview({
    required String userVocabularyId,
    required int quality,
    int? responseTimeMs,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/reviews',
        data: {
          'userVocabularyId': userVocabularyId,
          'quality': quality,
          if (responseTimeMs != null) 'responseTimeMs': responseTimeMs,
        },
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));

      // Le serveur renvoie `current` (nouvel état SRS) + `userVocabularyId`.
      // On construit un `UserVocabularyEntry` minimal à jour.
      final current = data['current'] as Map?;
      if (current == null) {
        return failure(const ServerFailure('Réponse incomplète'));
      }

      return success(
        UserVocabularyEntry(
          userVocabularyId: data['userVocabularyId'] as String,
          vocabularyId: '', // à compléter par le repository qui a le card
          state: _stateOf(current['state'] as String? ?? 'LEARNING'),
          isFavorite: false, // préservé localement par le repository
          repetitions: (current['repetitions'] as num?)?.toInt() ?? 0,
          intervalDays: (current['intervalDays'] as num?)?.toInt() ?? 0,
          easeFactor: (current['easeFactor'] as num?)?.toDouble() ?? 2.5,
          successRate: (current['successRate'] as num?)?.toDouble() ?? 0,
          difficulty: (current['difficulty'] as num?)?.toDouble() ?? 0,
          nextReviewAt: DateTime.tryParse(
            current['nextReviewAt'] as String? ?? '',
          )?.toLocal(),
        ),
      );
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  VocabularyState _stateOf(String raw) {
    switch (raw) {
      case 'LEARNING':
        return VocabularyState.learning;
      case 'REVIEW':
        return VocabularyState.review;
      case 'MASTERED':
        return VocabularyState.mastered;
      default:
        return VocabularyState.fresh;
    }
  }

  AppFailure _failureOf(Response<dynamic> r) {
    final body = ApiErrorBody.tryParse(r.data);
    final status = r.statusCode ?? 0;
    final msg = body?.message ?? 'Erreur ($status)';
    if (status == 401) return UnauthorizedFailure(msg);
    if (status == 404) return NotFoundFailure(msg);
    return ServerFailure(msg, status);
  }

  AppFailure _map(DioException e) {
    final m = e.error;
    if (m is AppFailure) return m;
    return const NetworkFailure();
  }
}

// Référence à UserVocabularyModel pour éviter un import inutilisé.
// ignore: unused_element
typedef _Keep = UserVocabularyModel;
