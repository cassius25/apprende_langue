import '../../../../core/utils/result.dart';
import '../entities/streak.dart';

abstract class StreakRepository {
  Future<Result<StreakInfo>> get();
  Future<Result<StreakCalendar>> calendar({int days = 30, int offset = 0});
}
