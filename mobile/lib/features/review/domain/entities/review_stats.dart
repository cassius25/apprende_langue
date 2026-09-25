import 'package:equatable/equatable.dart';

/// Statistiques d'une session de révision.
class ReviewSessionStats extends Equatable {
  const ReviewSessionStats({
    required this.totalCards,
    required this.answered,
    required this.correct,
    required this.wrong,
    required this.averageQuality,
    required this.averageResponseMs,
    required this.xpEarned,
    required this.totalXp,
    required this.userLevel,
    required this.streakCurrent,
    required this.streakLongest,
    required this.newBadges,
    required this.offlineQueued,
  });

  final int totalCards;
  final int answered;
  final int correct;
  final int wrong;
  final double averageQuality; // 0..5
  final int averageResponseMs;
  final int xpEarned;
  final int totalXp;
  final int userLevel;
  final int streakCurrent;
  final int streakLongest;
  final List<ReviewBadge> newBadges;
  final bool offlineQueued;

  double get successRate => answered == 0 ? 0 : correct / answered;

  int get successPercent => (successRate * 100).round();

  const ReviewSessionStats.empty()
    : totalCards = 0,
      answered = 0,
      correct = 0,
      wrong = 0,
      averageQuality = 0,
      averageResponseMs = 0,
      xpEarned = 0,
      totalXp = 0,
      userLevel = 1,
      streakCurrent = 0,
      streakLongest = 0,
      newBadges = const [],
      offlineQueued = false;

  @override
  List<Object?> get props => [answered, correct, xpEarned];
}

class ReviewBadge extends Equatable {
  const ReviewBadge({required this.code, required this.name, this.icon});
  final String code;
  final String name;
  final String? icon;

  @override
  List<Object?> get props => [code];
}

/// Résumé de la file de révision (aperçu sans réponse).
class ReviewQueueSummary extends Equatable {
  const ReviewQueueSummary({
    required this.dueCount,
    required this.newCount,
    required this.learningCount,
    required this.reviewCount,
    required this.masteredCount,
  });

  final int dueCount;
  final int newCount;
  final int learningCount;
  final int reviewCount;
  final int masteredCount;

  const ReviewQueueSummary.empty()
    : dueCount = 0,
      newCount = 0,
      learningCount = 0,
      reviewCount = 0,
      masteredCount = 0;

  @override
  List<Object?> get props => [
    dueCount,
    newCount,
    learningCount,
    reviewCount,
    masteredCount,
  ];
}
