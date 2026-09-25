import 'package:equatable/equatable.dart';

class StreakInfo extends Equatable {
  const StreakInfo({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalActiveDays,
    required this.activeToday,
    this.lastActiveDate,
  });

  final int currentStreak;
  final int longestStreak;
  final int totalActiveDays;
  final bool activeToday;
  final DateTime? lastActiveDate;

  factory StreakInfo.fromJson(Map<String, dynamic> json) => StreakInfo(
    currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
    longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
    totalActiveDays: (json['totalActiveDays'] as num?)?.toInt() ?? 0,
    activeToday: json['activeToday'] as bool? ?? false,
    lastActiveDate: DateTime.tryParse(
      json['lastActiveDate'] as String? ?? '',
    )?.toUtc(),
  );

  static StreakInfo empty() => const StreakInfo(
    currentStreak: 0,
    longestStreak: 0,
    totalActiveDays: 0,
    activeToday: false,
  );

  @override
  List<Object?> get props => [currentStreak, longestStreak, totalActiveDays];
}

class CalendarDay extends Equatable {
  const CalendarDay({
    required this.date,
    required this.active,
    required this.minutesLearned,
    required this.xpEarned,
    required this.wordsLearned,
    required this.wordsReviewed,
    required this.exercisesDone,
  });

  final DateTime date;
  final bool active;
  final int minutesLearned;
  final int xpEarned;
  final int wordsLearned;
  final int wordsReviewed;
  final int exercisesDone;

  factory CalendarDay.fromJson(Map<String, dynamic> json) => CalendarDay(
    date: DateTime.parse(json['date'] as String),
    active: json['active'] as bool? ?? false,
    minutesLearned: (json['minutesLearned'] as num?)?.toInt() ?? 0,
    xpEarned: (json['xpEarned'] as num?)?.toInt() ?? 0,
    wordsLearned: (json['wordsLearned'] as num?)?.toInt() ?? 0,
    wordsReviewed: (json['wordsReviewed'] as num?)?.toInt() ?? 0,
    exercisesDone: (json['exercisesDone'] as num?)?.toInt() ?? 0,
  );

  @override
  List<Object?> get props => [date, active];
}

class StreakCalendar extends Equatable {
  const StreakCalendar({
    required this.from,
    required this.to,
    required this.days,
  });

  final DateTime from;
  final DateTime to;
  final List<CalendarDay> days;

  factory StreakCalendar.fromJson(Map<String, dynamic> json) => StreakCalendar(
    from: DateTime.parse(json['from'] as String),
    to: DateTime.parse(json['to'] as String),
    days: ((json['days'] as List?) ?? const [])
        .whereType<Map>()
        .map((m) => CalendarDay.fromJson(Map<String, dynamic>.from(m)))
        .toList(growable: false),
  );

  @override
  List<Object?> get props => [from, to, days.length];
}
