import '../../../../core/network/network_info.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/daily_goal.dart';
import '../../domain/repositories/goal_repository.dart';
import '../datasources/goal_remote_datasource.dart';

class GoalRepositoryImpl implements GoalRepository {
  GoalRepositoryImpl({required this._remote, required this._network});

  final GoalRemoteDataSource _remote;
  final NetworkInfo _network;

  @override
  Future<Result<List<DailyGoal>>> list() => _remote.list();

  @override
  Future<Result<TodayGoal>> today() async {
    if (!await _network.isConnected) {
      return success(TodayGoal.empty());
    }
    return _remote.today();
  }

  @override
  Future<Result<DailyGoal>> upsert({
    required GoalType type,
    required int target,
  }) {
    return _remote.upsert(type: type, target: target);
  }

  @override
  Future<Result<DailyGoal>> update(String id, {int? target, bool? isActive}) =>
      _remote.update(id, target: target, isActive: isActive);

  @override
  Future<Result<void>> remove(String id) => _remote.remove(id);
}
