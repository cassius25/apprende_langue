import '../../../../core/utils/result.dart';
import '../entities/course.dart';

abstract class CourseRepository {
  Future<Result<List<Course>>> list({
    String? languageId,
    String? levelCode,
    int page = 1,
    int limit = 20,
    bool refresh = true,
  });

  Future<Result<Course>> getById(String id, {bool refresh = true});
}
