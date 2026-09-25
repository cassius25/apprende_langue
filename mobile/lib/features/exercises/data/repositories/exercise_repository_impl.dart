import 'package:dartz/dartz.dart';
import 'package:langapp/core/errors/app_failure.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_result.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_local_datasource.dart';
import '../datasources/exercise_remote_datasource.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  ExerciseRepositoryImpl({
    required this._remote,
    required this._local,
    required this._network,
  });

  final ExerciseRemoteDataSource _remote;
  final ExerciseLocalDataSource _local;
  final NetworkInfo _network;

  @override
  Future<Result<List<Exercise>>> listForLesson(
    String lessonId, {
    bool refresh = true,
  }) async {
    // 1) Cache-first
    final localList = await _local.readForLesson(lessonId);

    // 2) Refresh silencieux
    if (refresh && await _network.isConnected) {
      final remote = await _remote.listForLesson(lessonId);
      if (remote.isRight()) {
        final items = remote.valueOrNull!;
        await _local.cacheForLesson(lessonId, items);
        return success(items);
      }
      if (localList.isNotEmpty) return success(localList);
      return Left(remote.failureOrNull!);
    }

    return success(localList);
  }

  @override
  Future<Result<SubmitExerciseResult>> submit({
    required String exerciseId,
    required Map<String, dynamic> answer,
    int? responseTimeMs,
  }) async {
    if (!await _network.isConnected) {
      return const Left(NetworkFailure('Hors ligne — réessayez plus tard.'));
    }
    return _remote.submit(
      exerciseId: exerciseId,
      answer: answer,
      responseTimeMs: responseTimeMs,
    );
  }
}
