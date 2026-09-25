import '../../../../core/utils/result.dart';
import '../entities/statistics.dart';

abstract class StatisticsRepository {
  Future<Result<OverviewStats>> overview();
  Future<Result<ActivityChart>> activity({int days = 30, int offset = 0});
  Future<Result<List<SkillProgress>>> skills({String? languageId});
}
