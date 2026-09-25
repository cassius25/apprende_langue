import 'package:dartz/dartz.dart';
import 'package:langapp/core/errors/app_failure.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/storage/drift/app_database.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/lesson_local_datasource.dart';
import '../datasources/lesson_remote_datasource.dart';

class LessonRepositoryImpl implements LessonRepository {
  LessonRepositoryImpl({
    required this._remote,
    required this._local,
    required this._db,
    required this._tokens,
    required this._network,
  });

  final LessonRemoteDataSource _remote;
  final LessonLocalDataSource _local;
  final AppDatabase _db;
  final SecureTokenStorage _tokens;
  final NetworkInfo _network;
  static const _uuid = Uuid();

  @override
  Future<Result<Lesson>> getById(String id, {bool refresh = true}) async {
    // local d'abord
    final local = await _local.read(id);

    if (refresh && await _network.isConnected) {
      final remote = await _remote.getById(id);
      if (remote.isRight()) {
        final lesson = remote.valueOrNull!;
        await _local.cache(lesson);
        // ajoute progress local si présent
        return success(lesson);
      }
      if (local != null) return success(local);
      return Left(remote.failureOrNull!);
    }
    if (local != null) return success(local);
    return const Left(NotFoundFailure('Leçon introuvable'));
  }

  @override
  Future<Result<List<LessonMini>>> listByModule(String moduleId) async {
    final local = await _local.listByModule(moduleId);
    return success(local);
  }

  @override
  Future<Result<LessonCompletion>> complete(
    String lessonId, {
    int? score,
    int? timeSpentSec,
  }) async {
    final userId = await _tokens.readUserId();
    if (userId == null) return const Left(UnauthorizedFailure());

    // En ligne : serveur autoritaire
    if (await _network.isConnected) {
      final remote = await _remote.complete(
        lessonId,
        score: score,
        timeSpentSec: timeSpentSec,
      );
      if (remote.isRight()) {
        final c = remote.valueOrNull!;
        await _local.saveProgress(
          userId: userId,
          lessonId: lessonId,
          status: 'COMPLETED',
          score: c.progress.score,
          timeSpentSec: c.progress.timeSpentSec,
          completedAt: c.progress.completedAt ?? DateTime.now(),
        );
        return remote;
      }
    }

    // Hors ligne : mise à jour locale + enqueue
    final now = DateTime.now();
    final safeScore = score ?? 100;
    final safeTime = timeSpentSec ?? 0;
    await _local.saveProgress(
      userId: userId,
      lessonId: lessonId,
      status: 'COMPLETED',
      score: safeScore,
      timeSpentSec: safeTime,
      completedAt: now,
    );
    await _db.syncQueueDao.enqueue(
      id: _uuid.v4(),
      entity: 'user_progress',
      entityId: lessonId,
      op: 'UPSERT',
      payload: {
        'status': 'COMPLETED',
        'score': safeScore,
        'timeSpentSec': safeTime,
        'completedAt': now.toUtc().toIso8601String(),
      },
      clientTimestamp: now,
    );

    return success(
      LessonCompletion(
        xpEarned: 0,
        totalXp: 0,
        userLevel: 0,
        progress: LessonProgress(
          status: LessonProgressStatus.completed,
          score: safeScore,
          timeSpentSec: safeTime,
          completedAt: now,
        ),
      ),
    );
  }
}
