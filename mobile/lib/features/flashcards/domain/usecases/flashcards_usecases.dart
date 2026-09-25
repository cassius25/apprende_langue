import '../../../../core/utils/result.dart';
import '../../../vocabulary/domain/entities/user_vocabulary_entry.dart';
import '../entities/flashcard.dart';
import '../repositories/flashcards_repository.dart';

class LoadFlashcardsUseCase {
  LoadFlashcardsUseCase(this._r);
  final FlashcardsRepository _r;
  Future<Result<List<Flashcard>>> call({int limit = 50}) =>
      _r.loadDue(limit: limit);
}

class SubmitFlashcardAnswerUseCase {
  SubmitFlashcardAnswerUseCase(this._r);
  final FlashcardsRepository _r;
  Future<Result<UserVocabularyEntry>> call({
    required Flashcard card,
    required int quality,
    int? responseTimeMs,
  }) => _r.submitAnswer(
    card: card,
    quality: quality,
    responseTimeMs: responseTimeMs,
  );
}
