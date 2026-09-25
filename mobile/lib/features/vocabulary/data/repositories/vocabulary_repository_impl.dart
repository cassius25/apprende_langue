import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:langapp/core/errors/app_failure.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/storage/drift/app_database.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_vocabulary_entry.dart';
import '../../domain/entities/vocabulary_item.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../datasources/vocabulary_local_datasource.dart';
import '../datasources/vocabulary_remote_datasource.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  VocabularyRepositoryImpl({
    required this._remote,
    required this._local,
    required this._db,
    required this._tokens,
    required this._network,
  });

  final VocabularyRemoteDataSource _remote;
  final VocabularyLocalDataSource _local;
  final AppDatabase _db;
  final SecureTokenStorage _tokens;
  final NetworkInfo _network;
  static const _uuid = Uuid();

  Future<String?> _userId() => _tokens.readUserId();

  // ─────────────────────────────────────────────────────────
  // Catalogue
  // ─────────────────────────────────────────────────────────
  @override
  Future<Result<PaginatedVocabulary>> listCatalog({
    String? languageCode,
    String? levelCode,
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
    bool refresh = true,
  }) async {
    // 1) Lecture locale immédiate (cache-first).
    final localItems = await _local.readCatalog(search: search, limit: limit);
    final hasLocal = localItems.isNotEmpty;

    // 2) Refresh réseau (silencieux) si connecté et demandé.
    if (refresh && await _network.isConnected) {
      final remote = await _remote.listCatalog(
        languageCode: languageCode,
        levelCode: levelCode,
        category: category,
        search: search,
        page: page,
        limit: limit,
      );
      if (remote.isRight()) {
        await _local.cacheCatalogItems(remote.valueOrNull!);
        final refreshed = await _local.readCatalog(
          search: search,
          limit: limit,
        );
        return success(
          PaginatedVocabulary(items: refreshed, total: refreshed.length),
        );
      }
      // Fallback local si réseau OK mais API KO
      if (hasLocal) {
        return success(
          PaginatedVocabulary(items: localItems, total: localItems.length),
        );
      }
      return Left(remote.failureOrNull!);
    }

    return success(
      PaginatedVocabulary(items: localItems, total: localItems.length),
    );
  }

  @override
  Future<Result<VocabularyItem>> getById(
    String id, {
    bool refresh = true,
  }) async {
    final local = await _local.readOne(id);
    if (local != null && !refresh) return success(local);

    if (refresh && await _network.isConnected) {
      final remote = await _remote.getById(id);
      if (remote.isRight()) {
        await _local.cacheCatalogItems([remote.valueOrNull!]);
        return remote;
      }
      if (local != null) return success(local);
      return Left(remote.failureOrNull!);
    }
    if (local != null) return success(local);
    return const Left(NotFoundFailure('Mot introuvable'));
  }

  // ─────────────────────────────────────────────────────────
  // Mes mots
  // ─────────────────────────────────────────────────────────
  @override
  Future<Result<List<UserVocabularyEntry>>> listMyWords({
    VocabularyState? state,
    bool? isFavorite,
    String? languageCode,
    String? search,
    int limit = 200,
  }) async {
    final userId = await _userId();
    if (userId == null) return const Left(UnauthorizedFailure());

    // Refresh silencieux si connecté
    if (await _network.isConnected) {
      final remote = await _remote.listMyWords(
        state: state == null ? null : vocabularyStateToString(state),
        isFavorite: isFavorite,
        search: search,
        limit: limit,
      );
      if (remote.isRight()) {
        for (final e in remote.valueOrNull!) {
          await _local.upsertUserEntry(e, userId: userId);
        }
      }
    }

    final rows = await _local.readUserRows(
      userId: userId,
      state: state == null ? null : vocabularyStateToString(state),
      isFavorite: isFavorite,
      limit: limit,
    );
    return success(await _toEntries(rows));
  }

  @override
  Future<Result<List<UserVocabularyEntry>>> listDueForReview({
    int limit = 50,
  }) async {
    final userId = await _userId();
    if (userId == null) return const Left(UnauthorizedFailure());
    final rows = await _local.readDueForReview(userId, limit: limit);
    return success(await _toEntries(rows));
  }

  @override
  Future<int> countDueForReview() async {
    final userId = await _userId();
    if (userId == null) return 0;
    return _local.countDueForReview(userId);
  }

  // ─────────────────────────────────────────────────────────
  // Actions utilisateur
  // ─────────────────────────────────────────────────────────
  @override
  Future<Result<UserVocabularyEntry>> startLearning(String vocabularyId) async {
    final userId = await _userId();
    if (userId == null) return const Left(UnauthorizedFailure());

    // Idempotence locale : si déjà présent → renvoyer l'existant.
    final existing = await _local.readUserEntry(userId, vocabularyId);
    if (existing != null) {
      return success(await _toEntry(existing));
    }

    // 1) En ligne : POST
    if (await _network.isConnected) {
      final remote = await _remote.startLearning(vocabularyId);
      if (remote.isRight()) {
        final entry = remote.valueOrNull!;
        await _local.upsertUserEntry(entry, userId: userId);
        return remote;
      }
      // Fallback offline si API KO
    }

    // 2) Hors ligne : création locale + enqueue
    final now = DateTime.now();
    final entry = UserVocabularyEntry(
      userVocabularyId: _uuid.v4(),
      vocabularyId: vocabularyId,
      state: VocabularyState.learning,
      isFavorite: false,
      repetitions: 0,
      intervalDays: 0,
      easeFactor: 2.5,
      successRate: 0,
      difficulty: 0,
      nextReviewAt: now,
    );
    await _local.upsertUserEntry(entry, userId: userId);
    await _enqueueUserVocabulary(entry, userId: userId);
    return success(entry);
  }

  @override
  Future<Result<UserVocabularyEntry>> toggleFavorite(
    String vocabularyId,
    bool value,
  ) async {
    final userId = await _userId();
    if (userId == null) return const Left(UnauthorizedFailure());

    final existing = await _local.readUserEntry(userId, vocabularyId);
    if (existing == null) return const Left(NotFoundFailure('Mot non suivi'));

    if (await _network.isConnected) {
      final remote = await _remote.setFavorite(vocabularyId, value);
      if (remote.isRight()) {
        final entry = remote.valueOrNull!;
        await _local.upsertUserEntry(entry, userId: userId);
        return remote;
      }
    }

    // Mise à jour locale optimiste + enqueue
    await (_db.update(_db.localUserVocabulary)..where(
          (t) => t.userId.equals(userId) & t.vocabularyId.equals(vocabularyId),
        ))
        .write(LocalUserVocabularyCompanion(isFavorite: Value(value)));
    final updated = await _local.readUserEntry(userId, vocabularyId);
    final entry = await _toEntry(updated!);
    await _enqueueUserVocabulary(entry, userId: userId);
    return success(entry);
  }

  @override
  Future<Result<UserVocabularyEntry>> setState(
    String vocabularyId,
    VocabularyState state,
  ) async {
    final userId = await _userId();
    if (userId == null) return const Left(UnauthorizedFailure());

    if (await _network.isConnected) {
      final remote = await _remote.setState(
        vocabularyId,
        vocabularyStateToString(state),
      );
      if (remote.isRight()) {
        final entry = remote.valueOrNull!;
        await _local.upsertUserEntry(entry, userId: userId);
        return remote;
      }
    }

    final now = DateTime.now();
    await (_db.update(_db.localUserVocabulary)..where(
          (t) => t.userId.equals(userId) & t.vocabularyId.equals(vocabularyId),
        ))
        .write(
          LocalUserVocabularyCompanion(
            state: Value(vocabularyStateToString(state)),
            nextReviewAt: state == VocabularyState.mastered
                ? const Value(null)
                : Value(now),
            lastReviewedAt: state == VocabularyState.mastered
                ? Value(now)
                : const Value.absent(),
          ),
        );
    final updated = await _local.readUserEntry(userId, vocabularyId);
    final entry = await _toEntry(updated!);
    await _enqueueUserVocabulary(entry, userId: userId);
    return success(entry);
  }

  // ─────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────
  Future<UserVocabularyEntry> _toEntry(LocalUserVocabularyData row) async {
    final item = await _local.readOne(row.vocabularyId);
    return UserVocabularyEntry(
      userVocabularyId: row.id,
      vocabularyId: row.vocabularyId,
      state: vocabularyStateFromString(row.state),
      isFavorite: row.isFavorite,
      repetitions: row.repetitions,
      intervalDays: row.intervalDays,
      easeFactor: row.easeFactor,
      successRate: row.successRate,
      difficulty: row.difficulty,
      nextReviewAt: row.nextReviewAt,
      lastReviewedAt: row.lastReviewedAt,
      item: item,
    );
  }

  Future<List<UserVocabularyEntry>> _toEntries(
    List<LocalUserVocabularyData> rows,
  ) async {
    final out = <UserVocabularyEntry>[];
    for (final r in rows) {
      out.add(await _toEntry(r));
    }
    return out;
  }

  Future<void> _enqueueUserVocabulary(
    UserVocabularyEntry e, {
    required String userId,
  }) async {
    await _db.syncQueueDao.enqueue(
      id: _uuid.v4(),
      entity: 'user_vocabulary',
      entityId: e.vocabularyId,
      op: 'UPSERT',
      payload: {
        'state': vocabularyStateToString(e.state),
        'isFavorite': e.isFavorite,
        'repetitions': e.repetitions,
        'intervalDays': e.intervalDays,
        'easeFactor': e.easeFactor,
        'successRate': e.successRate,
        'difficulty': e.difficulty,
        'nextReviewAt': e.nextReviewAt?.toUtc().toIso8601String(),
        'lastReviewedAt': e.lastReviewedAt?.toUtc().toIso8601String(),
      },
      clientTimestamp: DateTime.now(),
    );
    // ignore: unused_local_variable
    final _ = userId;
  }
}
