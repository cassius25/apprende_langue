import 'package:dio/dio.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/result.dart';
import '../../../vocabulary/data/models/user_vocabulary_model.dart';
import '../../../vocabulary/domain/entities/user_vocabulary_entry.dart';
import '../../domain/entities/review_stats.dart';
import '../../domain/repositories/review_repository.dart';

/// Datasource remote du module révision.
/// - `GET /reviews/today` — file de révision
/// - `GET /reviews/due-count` — compteur
/// - `POST /reviews/batch` — soumission de session
class ReviewRemoteDataSource {
  ReviewRemoteDataSource(this._dio);
  final Dio _dio;

  Future<Result<int>> countDue() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/reviews/due-count',
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));
      final count = (data['dueCount'] as num?)?.toInt() ?? 0;
      return success(count);
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  /// Renvoie les cartes brutes (sans hydratation).
  /// Le repository les hydratera depuis Drift (flashcards locales).
  Future<Result<List<String>>> listDueUserVocabularyIds({
    String? languageId,
    int limit = 50,
    bool includeNew = false,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/reviews/today',
        queryParameters: {
          'limit': limit,
          if (languageId != null) 'languageId': languageId,
          if (includeNew) 'includeNew': true,
        },
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final raw = response.data?['data'];
      if (raw is! List) return success(const []);
      final ids = raw
          .whereType<Map>()
          .map((m) => m['userVocabularyId'] as String?)
          .whereType<String>()
          .toList(growable: false);
      return success(ids);
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  Future<Result<List<UserVocabularyEntry>>> submitBatch(
    List<ReviewAnswer> answers,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/reviews/batch',
        data: {
          'reviews': [
            for (final a in answers)
              {
                'userVocabularyId': a.flashcard.entry.userVocabularyId,
                'quality': a.quality,
                if (a.responseTimeMs != null)
                  'responseTimeMs': a.responseTimeMs,
              },
          ],
        },
      );
      if ((response.statusCode ?? 0) >= 400) {
        return failure(_failureOf(response));
      }
      final data = response.data?['data'];
      if (data is! Map) return failure(const ServerFailure('Réponse invalide'));

      final results = (data['results'] as List?) ?? const [];
      final out = <UserVocabularyEntry>[];
      for (final r in results) {
        if (r is! Map) continue;
        final current = r['current'] as Map?;
        if (current == null) continue;
        out.add(
          UserVocabularyEntry(
            userVocabularyId: r['userVocabularyId'] as String,
            vocabularyId: '', // injecté par le repository (qui a la carte)
            state: _stateOf(current['state'] as String? ?? 'LEARNING'),
            isFavorite: false,
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
      }

      // Le batch renvoie aussi les infos utilisateur globales.
      _lastBatchInfo = BatchInfo(
        totalXp: (data['totalXp'] as num?)?.toInt() ?? 0,
        userLevel: (data['userLevel'] as num?)?.toInt() ?? 1,
        xpEarned: (data['totalXpEarned'] as num?)?.toInt() ?? 0,
        streakCurrent:
            ((data['streak'] as Map?)?['currentStreak'] as num?)?.toInt() ?? 0,
        streakLongest:
            ((data['streak'] as Map?)?['longestStreak'] as num?)?.toInt() ?? 0,
        newBadges: ((data['newBadges'] as List?) ?? const [])
            .whereType<Map>()
            .map(
              (m) => ReviewBadge(
                code: m['code'] as String? ?? '',
                name: m['name'] as String? ?? '',
                icon: m['icon'] as String?,
              ),
            )
            .toList(growable: false),
      );

      return success(out);
    } on DioException catch (e) {
      return failure(_map(e));
    }
  }

  /// Infos globales de la dernière soumission batch (lues par le repository).
  BatchInfo? _lastBatchInfo;
  BatchInfo? consumeLastBatchInfo() {
    final info = _lastBatchInfo;
    _lastBatchInfo = null;
    return info;
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
    if (status == 401) {
      return UnauthorizedFailure(body?.message ?? 'Non autorisé');
    }
    if (status == 404) return NotFoundFailure(body?.message ?? 'Introuvable');
    return ServerFailure(body?.message ?? 'Erreur ($status)', status);
  }

  AppFailure _map(DioException e) {
    final m = e.error;
    if (m is AppFailure) return m;
    return const NetworkFailure();
  }
}

class BatchInfo {
  const BatchInfo({
    required this.xpEarned,
    required this.totalXp,
    required this.userLevel,
    required this.streakCurrent,
    required this.streakLongest,
    required this.newBadges,
  });
  final int xpEarned;
  final int totalXp;
  final int userLevel;
  final int streakCurrent;
  final int streakLongest;
  final List<ReviewBadge> newBadges;
}

// Référence pour éviter un import inutilisé
// ignore: unused_element
typedef _Keep = UserVocabularyModel;
