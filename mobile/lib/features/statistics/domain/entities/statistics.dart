import 'package:equatable/equatable.dart';

class OverviewStats extends Equatable {
  const OverviewStats({
    required this.totalMinutes,
    required this.last7DaysMinutes,
    required this.last30DaysMinutes,
    required this.wordsLearned,
    required this.wordsMastered,
    required this.wordsReviewedTotal,
    required this.wordsDueToday,
    required this.exercisesDone,
    required this.exercisesCorrect,
    required this.exercisesSuccessRate,
    required this.lessonsCompleted,
    required this.lessonsTotal,
    required this.xpTotal,
    required this.userLevel,
    required this.xpInLevel,
    required this.xpToNextLevel,
    required this.streakCurrent,
    required this.streakLongest,
    required this.totalActiveDays,
  });

  final int totalMinutes;
  final int last7DaysMinutes;
  final int last30DaysMinutes;
  final int wordsLearned;
  final int wordsMastered;
  final int wordsReviewedTotal;
  final int wordsDueToday;
  final int exercisesDone;
  final int exercisesCorrect;
  final double exercisesSuccessRate;
  final int lessonsCompleted;
  final int lessonsTotal;
  final int xpTotal;
  final int userLevel;
  final int xpInLevel;
  final int xpToNextLevel;
  final int streakCurrent;
  final int streakLongest;
  final int totalActiveDays;

  factory OverviewStats.fromJson(Map<String, dynamic> json) {
    final t = (json['timeLearnedMinutes'] as Map?) ?? const {};
    final w = (json['words'] as Map?) ?? const {};
    final e = (json['exercises'] as Map?) ?? const {};
    final l = (json['lessons'] as Map?) ?? const {};
    final x = (json['xp'] as Map?) ?? const {};
    final s = (json['streak'] as Map?) ?? const {};
    return OverviewStats(
      totalMinutes: (t['total'] as num?)?.toInt() ?? 0,
      last7DaysMinutes: (t['last7Days'] as num?)?.toInt() ?? 0,
      last30DaysMinutes: (t['last30Days'] as num?)?.toInt() ?? 0,
      wordsLearned: (w['learned'] as num?)?.toInt() ?? 0,
      wordsMastered: (w['mastered'] as num?)?.toInt() ?? 0,
      wordsReviewedTotal: (w['reviewedTotal'] as num?)?.toInt() ?? 0,
      wordsDueToday: (w['dueToday'] as num?)?.toInt() ?? 0,
      exercisesDone: (e['done'] as num?)?.toInt() ?? 0,
      exercisesCorrect: (e['correct'] as num?)?.toInt() ?? 0,
      exercisesSuccessRate: (e['successRate'] as num?)?.toDouble() ?? 0,
      lessonsCompleted: (l['completed'] as num?)?.toInt() ?? 0,
      lessonsTotal: (l['total'] as num?)?.toInt() ?? 0,
      xpTotal: (x['total'] as num?)?.toInt() ?? 0,
      userLevel: (x['level'] as num?)?.toInt() ?? 1,
      xpInLevel: (x['xpInLevel'] as num?)?.toInt() ?? 0,
      xpToNextLevel: (x['xpToNextLevel'] as num?)?.toInt() ?? 200,
      streakCurrent: (s['current'] as num?)?.toInt() ?? 0,
      streakLongest: (s['longest'] as num?)?.toInt() ?? 0,
      totalActiveDays: (s['totalActiveDays'] as num?)?.toInt() ?? 0,
    );
  }

  static OverviewStats empty() => const OverviewStats(
    totalMinutes: 0,
    last7DaysMinutes: 0,
    last30DaysMinutes: 0,
    wordsLearned: 0,
    wordsMastered: 0,
    wordsReviewedTotal: 0,
    wordsDueToday: 0,
    exercisesDone: 0,
    exercisesCorrect: 0,
    exercisesSuccessRate: 0,
    lessonsCompleted: 0,
    lessonsTotal: 0,
    xpTotal: 0,
    userLevel: 1,
    xpInLevel: 0,
    xpToNextLevel: 200,
    streakCurrent: 0,
    streakLongest: 0,
    totalActiveDays: 0,
  );

  @override
  List<Object?> get props => [xpTotal, wordsLearned, lessonsCompleted];
}

class ActivityDay extends Equatable {
  const ActivityDay({
    required this.date,
    required this.minutesLearned,
    required this.xpEarned,
    required this.wordsLearned,
    required this.wordsReviewed,
    required this.exercisesDone,
    required this.exercisesCorrect,
  });

  final DateTime date;
  final int minutesLearned;
  final int xpEarned;
  final int wordsLearned;
  final int wordsReviewed;
  final int exercisesDone;
  final int exercisesCorrect;

  factory ActivityDay.fromJson(Map<String, dynamic> json) => ActivityDay(
    date: DateTime.parse(json['date'] as String),
    minutesLearned: (json['minutesLearned'] as num?)?.toInt() ?? 0,
    xpEarned: (json['xpEarned'] as num?)?.toInt() ?? 0,
    wordsLearned: (json['wordsLearned'] as num?)?.toInt() ?? 0,
    wordsReviewed: (json['wordsReviewed'] as num?)?.toInt() ?? 0,
    exercisesDone: (json['exercisesDone'] as num?)?.toInt() ?? 0,
    exercisesCorrect: (json['exercisesCorrect'] as num?)?.toInt() ?? 0,
  );

  @override
  List<Object?> get props => [date];
}

class ActivityChart extends Equatable {
  const ActivityChart({
    required this.days,
    required this.totalMinutes,
    required this.totalXp,
  });

  final List<ActivityDay> days;
  final int totalMinutes;
  final int totalXp;

  factory ActivityChart.fromJson(Map<String, dynamic> json) {
    final totals = (json['totals'] as Map?) ?? const {};
    return ActivityChart(
      days: ((json['days'] as List?) ?? const [])
          .whereType<Map>()
          .map((m) => ActivityDay.fromJson(Map<String, dynamic>.from(m)))
          .toList(growable: false),
      totalMinutes: (totals['minutesLearned'] as num?)?.toInt() ?? 0,
      totalXp: (totals['xpEarned'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [days.length, totalMinutes];
}

class SkillProgress extends Equatable {
  const SkillProgress({
    required this.skill,
    required this.progressPercent,
    required this.metrics,
  });

  final String skill; // VOCABULARY, GRAMMAR, ...
  final double progressPercent;
  final Map<String, dynamic> metrics;

  factory SkillProgress.fromJson(Map<String, dynamic> json) => SkillProgress(
    skill: json['skill'] as String? ?? 'VOCABULARY',
    progressPercent: (json['progressPercent'] as num?)?.toDouble() ?? 0,
    metrics: (json['metrics'] as Map?)?.cast<String, dynamic>() ?? const {},
  );

  @override
  List<Object?> get props => [skill, progressPercent];
}
