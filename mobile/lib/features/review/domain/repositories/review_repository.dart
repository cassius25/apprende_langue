import '../../../../core/utils/result.dart';
import '../../../flashcards/domain/entities/flashcard.dart';
import '../entities/review_stats.dart';

/// Réponse d'une carte dans une session (avant soumission batch).
class ReviewAnswer {
  const ReviewAnswer({
    required this.flashcard,
    required this.quality,
    this.responseTimeMs,
  });

  final Flashcard flashcard;
  final int quality;
  final int? responseTimeMs;
}

abstract class ReviewRepository {
  /// Charge les cartes à réviser avec la configuration donnée.
  Future<Result<List<Flashcard>>> loadQueue({
    String? languageId,
    int limit = 20,
    bool includeNew = false,
    bool shuffle = false,
  });

  /// Compte les cartes à réviser (badge).
  Future<Result<int>> countDue();

  /// Résumé de la file (états).
  Future<Result<ReviewQueueSummary>> queueSummary();

  /// Soumet la session complète.
  /// - En ligne : `POST /reviews/batch`, applique les états serveur dans Drift.
  /// - Hors ligne : SM-2 local pour chaque carte + enqueue via SyncQueueDao.
  Future<Result<ReviewSessionStats>> submitBatch(List<ReviewAnswer> answers);
}
