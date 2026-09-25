import '../../../../core/utils/result.dart';
import '../entities/lesson.dart';
import '../repositories/lesson_repository.dart';

class GetLessonUseCase {
  GetLessonUseCase(this._r);
  final LessonRepository _r;
  Future<Result<Lesson>> call(String id) => _r.getById(id);
}

class ListLessonsByModuleUseCase {
  ListLessonsByModuleUseCase(this._r);
  final LessonRepository _r;
  Future<Result<List<LessonMini>>> call(String moduleId) =>
      _r.listByModule(moduleId);
}

class CompleteLessonUseCase {
  CompleteLessonUseCase(this._r);
  final LessonRepository _r;
  Future<Result<LessonCompletion>> call(
    String lessonId, {
    int? score,
    int? timeSpentSec,
  }) => _r.complete(lessonId, score: score, timeSpentSec: timeSpentSec);
}
