import 'package:langapp/features/vocabulary/domain/entities/user_vocabulary_entry.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/flashcard.dart';

abstract class FlashcardsRepository {
  /// Charge les flashcards dues (via vocabulaire local).
  Future<Result<List<Flashcard>>> loadDue({int limit = 50});

  /// Applique une réponse à une carte (quality 0..5).
  /// - En ligne : POST /reviews, met à jour Drift depuis la réponse serveur.
  /// - Hors ligne : SM-2 miroir local + enqueue.
  Future<Result<UserVocabularyEntry>> submitAnswer({
    required Flashcard card,
    required int quality,
    int? responseTimeMs,
  });
}
