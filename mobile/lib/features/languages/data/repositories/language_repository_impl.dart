import 'package:dartz/dartz.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/language.dart';
import '../../domain/repositories/language_repository.dart';
import '../datasources/language_local_datasource.dart';
import '../datasources/language_remote_datasource.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  LanguageRepositoryImpl({
    required this._remote,
    required this._local,
    required this._network,
  });

  final LanguageRemoteDataSource _remote;
  final LanguageLocalDataSource _local;
  final NetworkInfo _network;

  @override
  Future<Result<List<Language>>> listAll({bool refresh = true}) async {
    if (refresh && await _network.isConnected) {
      final remote = await _remote.listAll();
      if (remote.isRight()) {
        await _local.upsertAll(remote.valueOrNull!);
      } else {
        final local = await _local.readAll();
        if (local.isNotEmpty) return success(local);
        return Left(remote.failureOrNull!);
      }
    }
    final local = await _local.readAll();
    return success(local);
  }

  @override
  Future<List<Language>> readLocal() => _local.readAll();
}
