import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'progress_dao.g.dart';

@DriftAccessor(tables: [LocalUserProgress])
class ProgressDao extends DatabaseAccessor<AppDatabase>
    with _$ProgressDaoMixin {
  ProgressDao(super.db);

  Future<LocalUserProgressData?> getByLesson(String userId, String lessonId) {
    return (select(localUserProgress)
          ..where((t) => t.userId.equals(userId) & t.lessonId.equals(lessonId)))
        .getSingleOrNull();
  }

  Future<List<LocalUserProgressData>> getByUser(String userId) {
    return (select(
      localUserProgress,
    )..where((t) => t.userId.equals(userId))).get();
  }

  Future<int> countCompleted(String userId) async {
    final expr = localUserProgress.id.count();
    final q = selectOnly(localUserProgress)
      ..addColumns([expr])
      ..where(
        localUserProgress.userId.equals(userId) &
            localUserProgress.status.equals('COMPLETED'),
      );
    final row = await q.getSingle();
    return row.read(expr) ?? 0;
  }

  Future<void> upsert(LocalUserProgressCompanion row) {
    return into(localUserProgress).insertOnConflictUpdate(row);
  }

  Future<void> upsertAll(List<LocalUserProgressCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localUserProgress, rows));
  }
}
