import '../../../../core/utils/result.dart';
import '../../../flashcards/domain/entities/flashcard.dart';
import '../entities/review_stats.dart';
import '../repositories/review_repository.dart';

class LoadReviewQueueUseCase {
  LoadReviewQueueUseCase(this._r);
  final ReviewRepository _r;
  Future<Result<List<Flashcard>>> call({
    String? languageId,
    int limit = 20,
    bool includeNew = false,
    bool shuffle = false,
  }) => _r.loadQueue(
    languageId: languageId,
    limit: limit,
    includeNew: includeNew,
    shuffle: shuffle,
  );
}

class CountDueReviewsUseCase {
  CountDueReviewsUseCase(this._r);
  final ReviewRepository _r;
  Future<Result<int>> call() => _r.countDue();
}

class ReviewQueueSummaryUseCase {
  ReviewQueueSummaryUseCase(this._r);
  final ReviewRepository _r;
  Future<Result<ReviewQueueSummary>> call() => _r.queueSummary();
}

class SubmitReviewBatchUseCase {
  SubmitReviewBatchUseCase(this._r);
  final ReviewRepository _r;
  Future<Result<ReviewSessionStats>> call(List<ReviewAnswer> answers) =>
      _r.submitBatch(answers);
}
