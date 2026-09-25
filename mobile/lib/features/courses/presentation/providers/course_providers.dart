import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/drift/providers.dart';
import '../../data/datasources/course_local_datasource.dart';
import '../../data/datasources/course_remote_datasource.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../../domain/usecases/course_usecases.dart';

final courseRemoteProvider = Provider<CourseRemoteDataSource>(
  (ref) => CourseRemoteDataSource(ref.watch(dioProvider)),
);

final courseLocalProvider = Provider<CourseLocalDataSource>(
  (ref) => CourseLocalDataSource(ref.watch(appDatabaseProvider)),
);

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepositoryImpl(
    remote: ref.watch(courseRemoteProvider),
    local: ref.watch(courseLocalProvider),
    network: ref.watch(networkInfoProvider),
  );
});

final listCoursesUseCaseProvider = Provider<ListCoursesUseCase>(
  (ref) => ListCoursesUseCase(ref.watch(courseRepositoryProvider)),
);
final getCourseUseCaseProvider = Provider<GetCourseUseCase>(
  (ref) => GetCourseUseCase(ref.watch(courseRepositoryProvider)),
);

class CoursesQuery {
  const CoursesQuery({this.languageId, this.levelCode});
  final String? languageId;
  final String? levelCode;

  @override
  bool operator ==(Object other) =>
      other is CoursesQuery &&
      other.languageId == languageId &&
      other.levelCode == levelCode;

  @override
  int get hashCode => Object.hash(languageId, levelCode);
}

final coursesProvider = FutureProvider.family<List<Course>, CoursesQuery>((
  ref,
  q,
) async {
  final result = await ref
      .watch(listCoursesUseCaseProvider)
      .call(languageId: q.languageId, levelCode: q.levelCode);
  return result.fold((f) => throw f, (v) => v);
});

final courseDetailProvider = FutureProvider.family<Course, String>((
  ref,
  id,
) async {
  final result = await ref.watch(getCourseUseCaseProvider).call(id);
  return result.fold((f) => throw f, (v) => v);
});
