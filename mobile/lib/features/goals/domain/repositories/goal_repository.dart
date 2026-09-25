import '../../../../core/utils/result.dart';
import '../entities/daily_goal.dart';

class TodayGoal {
  const TodayGoal({
    required this.goal,
    required this.current,
    required this.target,
    required this.progressPercent,
    required this.achieved,
    required this.minutesLearned,
    required this.wordsLearned,
  });

  final DailyGoal? goal;
  final int current;
  final int target;
  final double progressPercent;
  final bool achieved;
  final int minutesLearned;
  final int wordsLearned;

  factory TodayGoal.fromJson(Map<String, dynamic> json) {
    final g = json['goal'] as Map<String, dynamic>?;
    return TodayGoal(
      goal: g == null
          ? null
          : DailyGoal(
              id: g['id'] as String? ?? '',
              type: goalTypeFromString(g['type'] as String? ?? 'MINUTES'),
              target: (g['target'] as num?)?.toInt() ?? 0,
              isActive: g['isActive'] as bool? ?? true,
            ),
      current: (json['current'] as num?)?.toInt() ?? 0,
      target: (json['target'] as num?)?.toInt() ?? 0,
      progressPercent: (json['progressPercent'] as num?)?.toDouble() ?? 0,
      achieved: json['achieved'] as bool? ?? false,
      minutesLearned: (json['minutesLearned'] as num?)?.toInt() ?? 0,
      wordsLearned: (json['wordsLearned'] as num?)?.toInt() ?? 0,
    );
  }

  static TodayGoal empty() => const TodayGoal(
    goal: null,
    current: 0,
    target: 0,
    progressPercent: 0,
    achieved: false,
    minutesLearned: 0,
    wordsLearned: 0,
  );
}

abstract class GoalRepository {
  Future<Result<List<DailyGoal>>> list();
  Future<Result<TodayGoal>> today();
  Future<Result<DailyGoal>> upsert({
    required GoalType type,
    required int target,
  });
  Future<Result<DailyGoal>> update(String id, {int? target, bool? isActive});
  Future<Result<void>> remove(String id);
}
