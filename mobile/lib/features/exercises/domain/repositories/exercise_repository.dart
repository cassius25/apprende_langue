import '../../../../core/utils/result.dart';
import '../entities/exercise.dart';
import '../entities/exercise_result.dart';

abstract class ExerciseRepository {
  /// Récupère les exercices d'une leçon (cache-first).
  Future<Result<List<Exercise>>> listForLesson(
    String lessonId, {
    bool refresh = true,
  });

  /// Soumet une réponse et reçoit la correction serveur.
  Future<Result<SubmitExerciseResult>> submit({
    required String exerciseId,
    required Map<String, dynamic> answer,
    int? responseTimeMs,
  });
}
