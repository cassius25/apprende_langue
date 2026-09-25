import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/drift/providers.dart';
import '../../data/datasources/vocabulary_local_datasource.dart';
import '../../data/datasources/vocabulary_remote_datasource.dart';
import '../../data/repositories/vocabulary_repository_impl.dart';
import '../../domain/entities/user_vocabulary_entry.dart';
import '../../domain/entities/vocabulary_item.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../../domain/usecases/vocabulary_usecases.dart';

final vocabularyRemoteDataSourceProvider = Provider<VocabularyRemoteDataSource>(
  (ref) {
    return VocabularyRemoteDataSource(ref.watch(dioProvider));
  },
);

final vocabularyLocalDataSourceProvider = Provider<VocabularyLocalDataSource>((
  ref,
) {
  return VocabularyLocalDataSource(ref.watch(appDatabaseProvider));
});

final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  return VocabularyRepositoryImpl(
    remote: ref.watch(vocabularyRemoteDataSourceProvider),
    local: ref.watch(vocabularyLocalDataSourceProvider),
    db: ref.watch(appDatabaseProvider),
    tokens: ref.watch(secureTokenStorageProvider),
    network: ref.watch(networkInfoProvider),
  );
});

// Use cases
final listCatalogUseCaseProvider = Provider<ListCatalogUseCase>(
  (ref) => ListCatalogUseCase(ref.watch(vocabularyRepositoryProvider)),
);
final getVocabularyDetailUseCaseProvider = Provider<GetVocabularyDetailUseCase>(
  (ref) => GetVocabularyDetailUseCase(ref.watch(vocabularyRepositoryProvider)),
);
final listMyWordsUseCaseProvider = Provider<ListMyWordsUseCase>(
  (ref) => ListMyWordsUseCase(ref.watch(vocabularyRepositoryProvider)),
);
final listDueForReviewUseCaseProvider = Provider<ListDueForReviewUseCase>(
  (ref) => ListDueForReviewUseCase(ref.watch(vocabularyRepositoryProvider)),
);
final countDueForReviewUseCaseProvider = Provider<CountDueForReviewUseCase>(
  (ref) => CountDueForReviewUseCase(ref.watch(vocabularyRepositoryProvider)),
);
final startLearningUseCaseProvider = Provider<StartLearningUseCase>(
  (ref) => StartLearningUseCase(ref.watch(vocabularyRepositoryProvider)),
);
final toggleFavoriteUseCaseProvider = Provider<ToggleFavoriteUseCase>(
  (ref) => ToggleFavoriteUseCase(ref.watch(vocabularyRepositoryProvider)),
);
final setVocabularyStateUseCaseProvider = Provider<SetVocabularyStateUseCase>(
  (ref) => SetVocabularyStateUseCase(ref.watch(vocabularyRepositoryProvider)),
);

// ─────────────────────────────────────────────────────────────
// Providers paramétrés
// ─────────────────────────────────────────────────────────────

class CatalogQuery {
  const CatalogQuery({
    this.languageCode,
    this.levelCode,
    this.category,
    this.search,
    this.page = 1,
    this.limit = 20,
  });
  final String? languageCode;
  final String? levelCode;
  final String? category;
  final String? search;
  final int page;
  final int limit;

  @override
  bool operator ==(Object other) =>
      other is CatalogQuery &&
      other.languageCode == languageCode &&
      other.levelCode == levelCode &&
      other.category == category &&
      other.search == search &&
      other.page == page &&
      other.limit == limit;

  @override
  int get hashCode =>
      Object.hash(languageCode, levelCode, category, search, page, limit);
}

final catalogProvider =
    FutureProvider.family<List<VocabularyItem>, CatalogQuery>((
      ref,
      query,
    ) async {
      final result = await ref
          .watch(listCatalogUseCaseProvider)
          .call(
            languageCode: query.languageCode,
            levelCode: query.levelCode,
            category: query.category,
            search: query.search,
            page: query.page,
            limit: query.limit,
          );
      return result.fold((f) => throw f, (v) => v.items);
    });

final vocabularyDetailProvider = FutureProvider.family<VocabularyItem, String>((
  ref,
  id,
) async {
  final result = await ref.watch(getVocabularyDetailUseCaseProvider).call(id);
  return result.fold((f) => throw f, (v) => v);
});

/// Compteur de mots à réviser (déjà posé en P12 sur Drift mais passe par le repo).
final dueVocabularyCountProvider = FutureProvider<int>((ref) async {
  return ref.watch(countDueForReviewUseCaseProvider).call();
});

/// File de révision complète (utilisée par flashcards).
final dueVocabularyListProvider = FutureProvider<List<UserVocabularyEntry>>((
  ref,
) async {
  final result = await ref
      .watch(listDueForReviewUseCaseProvider)
      .call(limit: 100);
  return result.fold((f) => throw f, (v) => v);
});
