import '../../../../core/utils/result.dart';
import '../entities/lesson.dart';

abstract class LessonRepository {
  Future<Result<Lesson>> getById(String id, {bool refresh = true});
  Future<Result<List<LessonMini>>> listByModule(String moduleId);
  Future<Result<LessonCompletion>> complete(
    String lessonId, {
    int? score,
    int? timeSpentSec,
  });
}

class LessonCompletion {
  const LessonCompletion({
    required this.xpEarned,
    required this.totalXp,
    required this.userLevel,
    required this.progress,
  });

  final int xpEarned;
  final int totalXp;
  final int userLevel;
  final LessonProgress progress;
}
