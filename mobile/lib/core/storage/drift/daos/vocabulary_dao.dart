import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'vocabulary_dao.g.dart';

@DriftAccessor(tables: [LocalUserVocabulary])
class VocabularyDao extends DatabaseAccessor<AppDatabase>
    with _$VocabularyDaoMixin {
  VocabularyDao(super.db);

  Future<LocalUserVocabularyData?> getByVocabularyId(
    String userId,
    String vocabularyId,
  ) {
    return (select(localUserVocabulary)..where(
          (t) =>
              t.userId.equals(userId) &
              t.vocabularyId.equals(vocabularyId) &
              t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<List<LocalUserVocabularyData>> getByUser(
    String userId, {
    String? state,
    bool? isFavorite,
    String? languageId,
    int limit = 200,
  }) {
    final q = select(localUserVocabulary)
      ..where((t) => t.userId.equals(userId) & t.deletedAt.isNull())
      ..limit(limit);
    if (state != null) q.where((t) => t.state.equals(state));
    if (isFavorite != null) q.where((t) => t.isFavorite.equals(isFavorite));
    q.orderBy([(t) => OrderingTerm.desc(t.serverUpdatedAt)]);
    // Le filtrage par langue se fait via jointure : `languageId` n'est pas
    // stocké directement (option : ajouter une colonne dénormalisée plus tard).
    // ignore: unused_local_variable
    final _ = languageId;
    return q.get();
  }

  /// File de révision locale : mots en LEARNING/REVIEW dont nextReviewAt <= maintenant.
  Future<List<LocalUserVocabularyData>> getDueForReview(
    String userId, {
    int limit = 50,
  }) {
    final now = DateTime.now();
    return (select(localUserVocabulary)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                t.deletedAt.isNull() &
                t.state.isIn(['LEARNING', 'REVIEW']) &
                (t.nextReviewAt.isNull() |
                    t.nextReviewAt.isSmallerOrEqualValue(now)),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.nextReviewAt)])
          ..limit(limit))
        .get();
  }

  Future<int> countDueForReview(String userId) async {
    final now = DateTime.now();
    final expr = localUserVocabulary.id.count();
    final q = selectOnly(localUserVocabulary)
      ..addColumns([expr])
      ..where(
        localUserVocabulary.userId.equals(userId) &
            localUserVocabulary.deletedAt.isNull() &
            localUserVocabulary.state.isIn(['LEARNING', 'REVIEW']) &
            (localUserVocabulary.nextReviewAt.isNull() |
                localUserVocabulary.nextReviewAt.isSmallerOrEqualValue(now)),
      );
    final row = await q.getSingle();
    return row.read(expr) ?? 0;
  }

  Future<void> upsert(LocalUserVocabularyCompanion row) {
    return into(localUserVocabulary).insertOnConflictUpdate(row);
  }

  Future<void> upsertAll(List<LocalUserVocabularyCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localUserVocabulary, rows));
  }

  /// Soft delete local (aligné avec le backend).
  Future<void> softDelete(String userId, String vocabularyId) {
    return (update(localUserVocabulary)..where(
          (t) => t.userId.equals(userId) & t.vocabularyId.equals(vocabularyId),
        ))
        .write(LocalUserVocabularyCompanion(deletedAt: Value(DateTime.now())));
  }
}
