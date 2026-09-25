import '../../../../core/utils/result.dart';
import '../entities/streak.dart';
import '../repositories/streak_repository.dart';

class GetStreakUseCase {
  GetStreakUseCase(this._r);
  final StreakRepository _r;
  Future<Result<StreakInfo>> call() => _r.get();
}

class GetStreakCalendarUseCase {
  GetStreakCalendarUseCase(this._r);
  final StreakRepository _r;
  Future<Result<StreakCalendar>> call({int days = 30, int offset = 0}) =>
      _r.calendar(days: days, offset: offset);
}
