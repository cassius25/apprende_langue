import 'dart:convert';

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'sync_queue_dao.g.dart';

@DriftAccessor(tables: [SyncQueueEntries])
class SyncQueueDao extends DatabaseAccessor<AppDatabase>
    with _$SyncQueueDaoMixin {
  SyncQueueDao(super.db);

  /// Ajoute une opération à pousser (idempotente grâce à la PK).
  Future<void> enqueue({
    required String id,
    required String entity,
    required String entityId,
    required String op,
    Map<String, dynamic>? payload,
    DateTime? clientTimestamp,
  }) async {
    // Si l'entité a déjà une opération pending pour le même (entity, entityId),
    // on la remplace (dernier état gagne).
    await (delete(syncQueueEntries)..where(
          (t) =>
              t.entity.equals(entity) &
              t.entityId.equals(entityId) &
              t.status.equals('pending'),
        ))
        .go();

    await into(syncQueueEntries).insert(
      SyncQueueEntriesCompanion.insert(
        id: id,
        entity: entity,
        entityId: entityId,
        op: op,
        payloadJson: Value(payload == null ? null : _encode(payload)),
        clientTimestamp: clientTimestamp ?? DateTime.now(),
      ),
    );
  }

  /// Récupère le prochain lot d'opérations à pousser (les plus anciennes).
  Future<List<SyncQueueEntry>> getPendingBatch({int limit = 50}) {
    return (select(syncQueueEntries)
          ..where((t) => t.status.isIn(['pending', 'failed']))
          ..where((t) => t.retryCount.isSmallerThanValue(5))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  Future<int> countPending() async {
    final expr = syncQueueEntries.id.count();
    final q = selectOnly(syncQueueEntries)
      ..addColumns([expr])
      ..where(syncQueueEntries.status.isIn(['pending', 'failed']));
    final row = await q.getSingle();
    return row.read(expr) ?? 0;
  }

  Future<void> markInFlight(List<String> ids) async {
    await (update(syncQueueEntries)..where((t) => t.id.isIn(ids))).write(
      SyncQueueEntriesCompanion(
        status: const Value('in_flight'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> markSynced(List<String> ids) async {
    await (update(syncQueueEntries)..where((t) => t.id.isIn(ids))).write(
      SyncQueueEntriesCompanion(
        status: const Value('synced'),
        errorMessage: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> markFailed(String id, String message) async {
    final row = await (select(
      syncQueueEntries,
    )..where((t) => t.id.equals(id))).getSingle();

    await (update(syncQueueEntries)..where((t) => t.id.equals(id))).write(
      SyncQueueEntriesCompanion(
        status: const Value('failed'),
        errorMessage: Value(message),
        retryCount: Value(row.retryCount + 1),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Future<void> markFailed(String id, String message) async {
  //   await (update(syncQueueEntries)..where((t) => t.id.equals(id))).write(
  //     SyncQueueEntriesCompanion(
  //       status: const Value('failed'),
  //       errorMessage: Value(message),
  //       retryCount: const CustomExpression<int>('retry_count + 1'),
  //       updatedAt: Value(DateTime.now()),
  //     ),
  //   );
  // }

  /// Remet en pending les opérations bloquées en `in_flight`
  /// (récupération après crash ou timeout).
  Future<void> resetInFlight() async {
    await (update(
      syncQueueEntries,
    )..where((t) => t.status.equals('in_flight'))).write(
      SyncQueueEntriesCompanion(
        status: const Value('pending'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Purge des entrées `synced` plus vieilles que [olderThan].
  Future<int> purgeSynced({Duration olderThan = const Duration(days: 7)}) {
    final cutoff = DateTime.now().subtract(olderThan);
    return (delete(syncQueueEntries)..where(
          (t) =>
              t.status.equals('synced') &
              t.updatedAt.isSmallerThanValue(cutoff),
        ))
        .go();
  }

  Future<void> wipe() => delete(syncQueueEntries).go();

  String _encode(Map<String, dynamic> map) => jsonEncode(map);
}
