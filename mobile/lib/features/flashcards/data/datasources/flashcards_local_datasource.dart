import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/storage/drift/app_database.dart';
import '../../../../core/utils/sm2.dart';
import '../../../vocabulary/domain/entities/user_vocabulary_entry.dart';

class FlashcardsLocalDataSource {
  FlashcardsLocalDataSource(this._db);
  final AppDatabase _db;
  static const _uuid = Uuid();

  /// Applique SM-2 local sur une carte et enqueue l'opération de sync.
  /// Retourne l'entrée mise à jour.
  Future<UserVocabularyEntry> applySm2Locally({
    required String userId,
    required String userVocabularyId,
    required int quality,
  }) async {
    // 1) Lit l'état actuel
    final row = await (_db.select(
      _db.localUserVocabulary,
    )..where((t) => t.id.equals(userVocabularyId))).getSingle();

    // 2) SM-2
    final output = Sm2.apply(
      Sm2Input(
        repetitions: row.repetitions,
        intervalDays: row.intervalDays,
        easeFactor: row.easeFactor,
        successRate: row.successRate,
        previousState: Sm2.parseState(row.state),
      ),
      quality,
    );

    // 3) Persiste
    await (_db.update(
      _db.localUserVocabulary,
    )..where((t) => t.id.equals(userVocabularyId))).write(
      LocalUserVocabularyCompanion(
        state: Value(Sm2.stateToString(output.state)),
        repetitions: Value(output.repetitions),
        intervalDays: Value(output.intervalDays),
        easeFactor: Value(output.easeFactor),
        successRate: Value(output.successRate),
        difficulty: Value(output.difficulty),
        nextReviewAt: Value(output.nextReviewAt),
        lastReviewedAt: Value(DateTime.now()),
        serverUpdatedAt: Value(DateTime.now()),
      ),
    );

    // 4) Enqueue l'opération user_vocabulary (payload complet)
    final updated = await (_db.select(
      _db.localUserVocabulary,
    )..where((t) => t.id.equals(userVocabularyId))).getSingle();

    await _db.syncQueueDao.enqueue(
      id: _uuid.v4(),
      entity: 'user_vocabulary',
      entityId: updated.vocabularyId,
      op: 'UPSERT',
      payload: {
        'state': updated.state,
        'isFavorite': updated.isFavorite,
        'repetitions': updated.repetitions,
        'intervalDays': updated.intervalDays,
        'easeFactor': updated.easeFactor,
        'successRate': updated.successRate,
        'difficulty': updated.difficulty,
        'nextReviewAt': updated.nextReviewAt?.toUtc().toIso8601String(),
        'lastReviewedAt': updated.lastReviewedAt?.toUtc().toIso8601String(),
      },
      clientTimestamp: DateTime.now(),
    );

    // 5) Retour
    return UserVocabularyEntry(
      userVocabularyId: updated.id,
      vocabularyId: updated.vocabularyId,
      state: vocabularyStateFromString(updated.state),
      isFavorite: updated.isFavorite,
      repetitions: updated.repetitions,
      intervalDays: updated.intervalDays,
      easeFactor: updated.easeFactor,
      successRate: updated.successRate,
      difficulty: updated.difficulty,
      nextReviewAt: updated.nextReviewAt,
      lastReviewedAt: updated.lastReviewedAt,
    );
  }
}
