import '../../../../core/utils/result.dart';
import '../entities/statistics.dart';
import '../repositories/statistics_repository.dart';

class GetOverviewStatsUseCase {
  GetOverviewStatsUseCase(this._r);
  final StatisticsRepository _r;
  Future<Result<OverviewStats>> call() => _r.overview();
}

class GetActivityChartUseCase {
  GetActivityChartUseCase(this._r);
  final StatisticsRepository _r;
  Future<Result<ActivityChart>> call({int days = 30, int offset = 0}) =>
      _r.activity(days: days, offset: offset);
}

class GetSkillsUseCase {
  GetSkillsUseCase(this._r);
  final StatisticsRepository _r;
  Future<Result<List<SkillProgress>>> call({String? languageId}) =>
      _r.skills(languageId: languageId);
}
