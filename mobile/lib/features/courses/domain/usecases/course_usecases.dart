import '../../../../core/utils/result.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

class ListCoursesUseCase {
  ListCoursesUseCase(this._r);
  final CourseRepository _r;
  Future<Result<List<Course>>> call({
    String? languageId,
    String? levelCode,
    int page = 1,
    int limit = 20,
  }) => _r.list(
    languageId: languageId,
    levelCode: levelCode,
    page: page,
    limit: limit,
  );
}

class GetCourseUseCase {
  GetCourseUseCase(this._r);
  final CourseRepository _r;
  Future<Result<Course>> call(String id) => _r.getById(id);
}
