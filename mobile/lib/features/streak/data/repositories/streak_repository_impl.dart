import '../../../../core/network/network_info.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/streak.dart';
import '../../domain/repositories/streak_repository.dart';
import '../datasources/streak_remote_datasource.dart';

class StreakRepositoryImpl implements StreakRepository {
  StreakRepositoryImpl({required this._remote, required this._network});

  final StreakRemoteDataSource _remote;
  final NetworkInfo _network;

  @override
  Future<Result<StreakInfo>> get() async {
    if (!await _network.isConnected) return success(StreakInfo.empty());
    return _remote.get();
  }

  @override
  Future<Result<StreakCalendar>> calendar({
    int days = 30,
    int offset = 0,
  }) async {
    if (!await _network.isConnected) {
      return success(
        StreakCalendar(
          from: DateTime.now().subtract(Duration(days: days - 1)),
          to: DateTime.now(),
          days: const [],
        ),
      );
    }
    return _remote.calendar(days: days, offset: offset);
  }
}
