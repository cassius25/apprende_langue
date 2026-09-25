import 'package:dartz/dartz.dart';
import 'package:langapp/core/errors/app_failure.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_local_datasource.dart';
import '../datasources/course_remote_datasource.dart';

class CourseRepositoryImpl implements CourseRepository {
  CourseRepositoryImpl({
    required this._remote,
    required this._local,
    required this._network,
  });

  final CourseRemoteDataSource _remote;
  final CourseLocalDataSource _local;
  final NetworkInfo _network;

  @override
  Future<Result<List<Course>>> list({
    String? languageId,
    String? levelCode,
    int page = 1,
    int limit = 20,
    bool refresh = true,
  }) async {
    if (refresh && await _network.isConnected) {
      final remote = await _remote.list(
        languageId: languageId,
        levelCode: levelCode,
        page: page,
        limit: limit,
      );
      if (remote.isRight()) {
        await _local.cacheList(remote.valueOrNull!);
      } else {
        final local = await _local.readList(languageId: languageId);
        if (local.isNotEmpty) return success(local);
        return Left(remote.failureOrNull!);
      }
    }
    return success(await _local.readList(languageId: languageId));
  }

  @override
  Future<Result<Course>> getById(String id, {bool refresh = true}) async {
    if (refresh && await _network.isConnected) {
      final remote = await _remote.getById(id);
      if (remote.isRight()) {
        final course = remote.valueOrNull!;
        await _local.cacheList([course]);
        return success(course);
      }
    }
    final local = await _local.readOne(id);
    if (local != null) return success(local);
    return const Left(NotFoundFailure('Cours introuvable'));
  }
}
