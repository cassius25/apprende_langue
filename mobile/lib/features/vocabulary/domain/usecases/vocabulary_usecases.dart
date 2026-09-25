import '../../../../core/utils/result.dart';
import '../entities/user_vocabulary_entry.dart';
import '../entities/vocabulary_item.dart';
import '../repositories/vocabulary_repository.dart';

class ListCatalogUseCase {
  ListCatalogUseCase(this._r);
  final VocabularyRepository _r;
  Future<Result<PaginatedVocabulary>> call({
    String? languageCode,
    String? levelCode,
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
  }) => _r.listCatalog(
    languageCode: languageCode,
    levelCode: levelCode,
    category: category,
    search: search,
    page: page,
    limit: limit,
  );
}

class GetVocabularyDetailUseCase {
  GetVocabularyDetailUseCase(this._r);
  final VocabularyRepository _r;
  Future<Result<VocabularyItem>> call(String id) => _r.getById(id);
}

class ListMyWordsUseCase {
  ListMyWordsUseCase(this._r);
  final VocabularyRepository _r;
  Future<Result<List<UserVocabularyEntry>>> call({
    VocabularyState? state,
    bool? isFavorite,
    String? languageCode,
    String? search,
    int limit = 200,
  }) => _r.listMyWords(
    state: state,
    isFavorite: isFavorite,
    languageCode: languageCode,
    search: search,
    limit: limit,
  );
}

class ListDueForReviewUseCase {
  ListDueForReviewUseCase(this._r);
  final VocabularyRepository _r;
  Future<Result<List<UserVocabularyEntry>>> call({int limit = 50}) =>
      _r.listDueForReview(limit: limit);
}

class CountDueForReviewUseCase {
  CountDueForReviewUseCase(this._r);
  final VocabularyRepository _r;
  Future<int> call() => _r.countDueForReview();
}

class StartLearningUseCase {
  StartLearningUseCase(this._r);
  final VocabularyRepository _r;
  Future<Result<UserVocabularyEntry>> call(String vocabularyId) =>
      _r.startLearning(vocabularyId);
}

class ToggleFavoriteUseCase {
  ToggleFavoriteUseCase(this._r);
  final VocabularyRepository _r;
  Future<Result<UserVocabularyEntry>> call(String vocabularyId, bool value) =>
      _r.toggleFavorite(vocabularyId, value);
}

class SetVocabularyStateUseCase {
  SetVocabularyStateUseCase(this._r);
  final VocabularyRepository _r;
  Future<Result<UserVocabularyEntry>> call(
    String vocabularyId,
    VocabularyState state,
  ) => _r.setState(vocabularyId, state);
}
