import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'daos/catalog_dao.dart';
import 'daos/progress_dao.dart';
import 'daos/sync_queue_dao.dart';
import 'daos/user_dao.dart';
import 'daos/vocabulary_dao.dart';

/// Base de données Drift. À override dans `main.dart` après création explicite
/// (ou à laisser tel quel avec le constructeur par défaut).
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// DAO providers dérivés.
final catalogDaoProvider = Provider<CatalogDao>((ref) {
  return ref.watch(appDatabaseProvider).catalogDao;
});

final userDaoProvider = Provider<UserDao>((ref) {
  return ref.watch(appDatabaseProvider).userDao;
});

final vocabularyDaoProvider = Provider<VocabularyDao>((ref) {
  return ref.watch(appDatabaseProvider).vocabularyDao;
});

final progressDaoProvider = Provider<ProgressDao>((ref) {
  return ref.watch(appDatabaseProvider).progressDao;
});

final syncQueueDaoProvider = Provider<SyncQueueDao>((ref) {
  return ref.watch(appDatabaseProvider).syncQueueDao;
});

// ─────────────────────────────────────────────────────────────
// Streams réactifs (consommables directement dans les widgets)
// ─────────────────────────────────────────────────────────────

/// Nombre d'opérations en attente de synchronisation (badge UI).
final pendingSyncCountProvider = StreamProvider<int>((ref) {
  final dao = ref.watch(syncQueueDaoProvider);
  // Poll léger : on pourrait exposer un stream Drift dédié.
  return Stream.periodic(
    const Duration(seconds: 3),
    (_) => dao.countPending(),
  ).asyncMap((future) => future);
});
