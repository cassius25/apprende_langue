import '../../../../core/utils/result.dart';
import '../entities/daily_goal.dart';
import '../repositories/goal_repository.dart';

class ListGoalsUseCase {
  ListGoalsUseCase(this._r);
  final GoalRepository _r;
  Future<Result<List<DailyGoal>>> call() => _r.list();
}

class TodayGoalUseCase {
  TodayGoalUseCase(this._r);
  final GoalRepository _r;
  Future<Result<TodayGoal>> call() => _r.today();
}

class UpsertGoalUseCase {
  UpsertGoalUseCase(this._r);
  final GoalRepository _r;
  Future<Result<DailyGoal>> call({
    required GoalType type,
    required int target,
  }) => _r.upsert(type: type, target: target);
}

class UpdateGoalUseCase {
  UpdateGoalUseCase(this._r);
  final GoalRepository _r;
  Future<Result<DailyGoal>> call(String id, {int? target, bool? isActive}) =>
      _r.update(id, target: target, isActive: isActive);
}

class RemoveGoalUseCase {
  RemoveGoalUseCase(this._r);
  final GoalRepository _r;
  Future<Result<void>> call(String id) => _r.remove(id);
}
