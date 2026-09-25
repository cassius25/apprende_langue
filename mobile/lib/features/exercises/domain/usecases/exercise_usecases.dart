import '../../../../core/utils/result.dart';
import '../entities/exercise.dart';
import '../entities/exercise_result.dart';
import '../repositories/exercise_repository.dart';

class ListExercisesForLessonUseCase {
  ListExercisesForLessonUseCase(this._r);
  final ExerciseRepository _r;
  Future<Result<List<Exercise>>> call(String lessonId, {bool refresh = true}) =>
      _r.listForLesson(lessonId, refresh: refresh);
}

class SubmitExerciseUseCase {
  SubmitExerciseUseCase(this._r);
  final ExerciseRepository _r;
  Future<Result<SubmitExerciseResult>> call({
    required String exerciseId,
    required Map<String, dynamic> answer,
    int? responseTimeMs,
  }) => _r.submit(
    exerciseId: exerciseId,
    answer: answer,
    responseTimeMs: responseTimeMs,
  );
}
