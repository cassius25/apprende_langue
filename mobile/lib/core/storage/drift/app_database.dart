import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'daos/catalog_dao.dart';
import 'daos/progress_dao.dart';
import 'daos/sync_queue_dao.dart';
import 'daos/user_dao.dart';
import 'daos/vocabulary_dao.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    // Catalog
    LocalLanguages,
    LocalLevels,
    LocalCourses,
    LocalModules,
    LocalLessons,
    LocalLessonContents,
    LocalVocabulary,
    LocalVocabularyTranslations,
    LocalVocabularyExamples,
    LocalExercises,
    LocalExerciseOptions,
    // User
    LocalUserProfile,
    LocalUserLanguages,
    LocalUserProgress,
    LocalUserVocabulary,
    LocalDailyGoals,
    LocalStreaks,
    LocalDailyActivities,
    LocalUserBadges,
    // Sync
    SyncQueueEntries,
  ],
  daos: [CatalogDao, UserDao, VocabularyDao, ProgressDao, SyncQueueDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructeur pour tests en mémoire (utiliser `NativeDatabase.memory()`).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createIndexes();
    },
    onUpgrade: (m, from, to) async {
      // Aucune migration pour l'instant — version 1.
      // Exemple pour v1 → v2 :
      // if (from < 2) {
      //   await m.addColumn(localVocabulary, localVocabulary.someNewColumn);
      // }
    },
    beforeOpen: (details) async {
      // Active les clés étrangères (bonne pratique même sans FK explicites).
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _createIndexes() async {
    // Index de recherche locale
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vocab_word ON local_vocabulary (word)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_user_vocab_state ON local_user_vocabulary (user_id, state)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_user_vocab_next ON local_user_vocabulary (user_id, next_review_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_sync_status ON sync_queue_entries (status, created_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_daily_activity_date ON local_daily_activities (user_id, date)',
    );
  }

  /// Purge complète (logout, reset).
  Future<void> wipeAll() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  /// Purge des entrées de sync déjà traitées, plus vieilles que [olderThan].
  Future<int> purgeSyncedEntries({
    Duration olderThan = const Duration(days: 7),
  }) {
    final cutoff = DateTime.now().subtract(olderThan);
    return (delete(syncQueueEntries)..where(
          (t) =>
              t.status.equals('synced') &
              t.updatedAt.isSmallerThanValue(cutoff),
        ))
        .go();
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'langapp',
    native: const DriftNativeOptions(
      // Base située dans le répertoire documents de l'app.
      databaseDirectory: getApplicationSupportDirectory,
    ),
  );
}
