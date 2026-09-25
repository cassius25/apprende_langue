import '../../domain/entities/exercise_result.dart';

class CorrectionModel {
  const CorrectionModel({required this.json});
  final Map<String, dynamic> json;

  factory CorrectionModel.fromApi(Map<String, dynamic> json) =>
      CorrectionModel(json: json);

  SubmitExerciseResult toEntity() {
    return SubmitExerciseResult(
      exerciseId: json['exerciseId'] as String,
      isCorrect: json['isCorrect'] as bool? ?? false,
      score: (json['score'] as num?)?.toInt() ?? 0,
      correctAnswer: json['correctAnswer'] as String?,
      explanation: json['explanation'] as String?,
      details: (json['details'] as Map?)?.cast<String, dynamic>(),
      xpEarned: (json['xpEarned'] as num?)?.toInt() ?? 0,
      totalXp: (json['totalXp'] as num?)?.toInt() ?? 0,
      userLevel: (json['userLevel'] as num?)?.toInt() ?? 1,
    );
  }
}
