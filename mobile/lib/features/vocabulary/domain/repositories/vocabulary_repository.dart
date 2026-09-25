import 'package:langapp/core/utils/result.dart';
import 'package:langapp/features/vocabulary/domain/entities/user_vocabulary_entry.dart';
import 'package:langapp/features/vocabulary/domain/entities/vocabulary_item.dart';

class PaginatedVocabulary {
  const PaginatedVocabulary({required this.items, required this.total});
  final List<VocabularyItem> items;
  final int total;
}

abstract class VocabularyRepository {
  /// Catalogue : liste filtrée depuis Drift (avec refresh réseau en arrière-plan).
  Future<Result<PaginatedVocabulary>> listCatalog({
    String? languageCode,
    String? levelCode,
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
    bool refresh = true,
  });

  /// Détail d'un mot (local d'abord, fallback réseau).
  Future<Result<VocabularyItem>> getById(String id, {bool refresh = true});

  /// Mes mots : filtrés par état / favori / langue.
  Future<Result<List<UserVocabularyEntry>>> listMyWords({
    VocabularyState? state,
    bool? isFavorite,
    String? languageCode,
    String? search,
    int limit = 200,
  });

  /// Mots à réviser maintenant (local).
  Future<Result<List<UserVocabularyEntry>>> listDueForReview({int limit = 50});

  /// Compteur local de mots à réviser (badge UI).
  Future<int> countDueForReview();

  /// Démarre l'apprentissage d'un mot (idempotent).
  Future<Result<UserVocabularyEntry>> startLearning(String vocabularyId);

  /// Bascule le favori.
  Future<Result<UserVocabularyEntry>> toggleFavorite(
    String vocabularyId,
    bool value,
  );

  /// Change l'état (MASTERED manuel, reset).
  Future<Result<UserVocabularyEntry>> setState(
    String vocabularyId,
    VocabularyState state,
  );
}
