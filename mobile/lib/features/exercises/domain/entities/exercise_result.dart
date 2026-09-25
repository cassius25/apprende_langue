import 'package:equatable/equatable.dart';

/// Résultat de correction d'un exercice (miroir du DTO backend).
class CorrectionResult extends Equatable {
  const CorrectionResult({
    required this.exerciseId,
    required this.isCorrect,
    required this.score,
    this.correctAnswer,
    this.explanation,
    this.details,
  });

  final String exerciseId;
  final bool isCorrect;
  final int score;
  final String? correctAnswer;
  final String? explanation;
  final Map<String, dynamic>? details;

  @override
  List<Object?> get props => [exerciseId, isCorrect, score];
}

/// Résultat enrichi d'une soumission individuelle.
class SubmitExerciseResult extends CorrectionResult {
  const SubmitExerciseResult({
    required super.exerciseId,
    required super.isCorrect,
    required super.score,
    required this.xpEarned,
    required this.totalXp,
    required this.userLevel,
    super.correctAnswer,
    super.explanation,
    super.details,
  });

  final int xpEarned;
  final int totalXp;
  final int userLevel;
}
