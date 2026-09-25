/// Miroir Dart de `backend/src/modules/reviews/review.srs.ts`.
/// Utilisé quand l'appareil est hors ligne pour mettre à jour localement
/// l'état SRS avant la synchronisation.
library;

import 'dart:math' as math;

enum Sm2State { newState, learning, review, mastered }

class Sm2Input {
  const Sm2Input({
    required this.repetitions,
    required this.intervalDays,
    required this.easeFactor,
    required this.successRate,
    required this.previousState,
  });

  final int repetitions;
  final int intervalDays;
  final double easeFactor;
  final double successRate;
  final Sm2State previousState;
}

class Sm2Output {
  const Sm2Output({
    required this.repetitions,
    required this.intervalDays,
    required this.easeFactor,
    required this.successRate,
    required this.difficulty,
    required this.state,
    required this.nextReviewAt,
    required this.isCorrect,
  });

  final int repetitions;
  final int intervalDays;
  final double easeFactor;
  final double successRate;
  final double difficulty;
  final Sm2State state;
  final DateTime nextReviewAt;
  final bool isCorrect;
}

class Sm2 {
  const Sm2._();

  static const double _minEase = 1.3;
  static const double _maxEase = 3.0;
  static const int _maxIntervalDays = 365;
  static const double _emaAlpha = 0.3;
  static const int _masteredRepetitions = 5;
  static const int _masteredInterval = 21;

  static bool _isSuccess(int q) => q >= 3;

  static double _newEase(int q, double ef) {
    final delta = 0.1 - (5 - q) * (0.08 + (5 - q) * 0.02);
    return (ef + delta).clamp(_minEase, _maxEase);
  }

  static int _nextInterval(int q, int reps, int current, double ef) {
    if (!_isSuccess(q)) return 1;
    if (reps == 0) return 1;
    if (reps == 1) return 6;
    return math.min(_maxIntervalDays, math.max(1, (current * ef).round()));
  }

  static Sm2State _deriveState(int reps, int interval, Sm2State previous) {
    if (reps == 0) return Sm2State.learning;
    if (reps >= _masteredRepetitions && interval >= _masteredInterval) {
      return Sm2State.mastered;
    }
    if (previous == Sm2State.newState) return Sm2State.learning;
    return reps >= 2 ? Sm2State.review : Sm2State.learning;
  }

  static Sm2Output apply(Sm2Input input, int quality) {
    final q = quality.clamp(0, 5);
    final isCorrect = _isSuccess(q);
    final newEf = _newEase(q, input.easeFactor);

    final int repetitions;
    final int intervalDays;
    if (!isCorrect) {
      repetitions = 0;
      intervalDays = 1;
    } else {
      intervalDays = _nextInterval(
        q,
        input.repetitions,
        input.intervalDays,
        newEf,
      );
      repetitions = input.repetitions + 1;
    }

    final newSuccess = input.successRate == 0
        ? (isCorrect ? 1.0 : 0.0)
        : input.successRate * (1 - _emaAlpha) + (isCorrect ? 1 : 0) * _emaAlpha;

    final difficulty = ((2.5 - newEf) / 1.2).clamp(0.0, 1.0);
    final state = _deriveState(repetitions, intervalDays, input.previousState);
    final nextReviewAt = DateTime.now().add(Duration(days: intervalDays));

    return Sm2Output(
      repetitions: repetitions,
      intervalDays: intervalDays,
      easeFactor: double.parse(newEf.toStringAsFixed(3)),
      successRate: double.parse(newSuccess.toStringAsFixed(3)),
      difficulty: double.parse(difficulty.toStringAsFixed(3)),
      state: state,
      nextReviewAt: nextReviewAt,
      isCorrect: isCorrect,
    );
  }

  static Sm2State parseState(String raw) {
    switch (raw) {
      case 'LEARNING':
        return Sm2State.learning;
      case 'REVIEW':
        return Sm2State.review;
      case 'MASTERED':
        return Sm2State.mastered;
      default:
        return Sm2State.newState;
    }
  }

  static String stateToString(Sm2State s) {
    switch (s) {
      case Sm2State.newState:
        return 'NEW';
      case Sm2State.learning:
        return 'LEARNING';
      case Sm2State.review:
        return 'REVIEW';
      case Sm2State.mastered:
        return 'MASTERED';
    }
  }
}
