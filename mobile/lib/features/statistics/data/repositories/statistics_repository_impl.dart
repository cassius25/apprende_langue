import '../../../../core/network/network_info.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/statistics.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_remote_datasource.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  StatisticsRepositoryImpl({required this._remote, required this._network});

  final StatisticsRemoteDataSource _remote;
  final NetworkInfo _network;

  @override
  Future<Result<OverviewStats>> overview() async {
    if (!await _network.isConnected) return success(OverviewStats.empty());
    return _remote.overview();
  }

  @override
  Future<Result<ActivityChart>> activity({
    int days = 30,
    int offset = 0,
  }) async {
    if (!await _network.isConnected) {
      return success(
        const ActivityChart(days: [], totalMinutes: 0, totalXp: 0),
      );
    }
    return _remote.activity(days: days, offset: offset);
  }

  @override
  Future<Result<List<SkillProgress>>> skills({String? languageId}) async {
    if (!await _network.isConnected) return success(const []);
    return _remote.skills(languageId: languageId);
  }
}
