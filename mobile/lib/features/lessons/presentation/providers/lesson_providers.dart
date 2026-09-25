import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/drift/providers.dart';
import '../../data/datasources/lesson_local_datasource.dart';
import '../../data/datasources/lesson_remote_datasource.dart';
import '../../data/repositories/lesson_repository_impl.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../../domain/usecases/lesson_usecases.dart';

final lessonRemoteProvider = Provider<LessonRemoteDataSource>(
  (ref) => LessonRemoteDataSource(ref.watch(dioProvider)),
);
final lessonLocalProvider = Provider<LessonLocalDataSource>(
  (ref) => LessonLocalDataSource(ref.watch(appDatabaseProvider)),
);
final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return LessonRepositoryImpl(
    remote: ref.watch(lessonRemoteProvider),
    local: ref.watch(lessonLocalProvider),
    db: ref.watch(appDatabaseProvider),
    tokens: ref.watch(secureTokenStorageProvider),
    network: ref.watch(networkInfoProvider),
  );
});

final getLessonUseCaseProvider = Provider<GetLessonUseCase>(
  (ref) => GetLessonUseCase(ref.watch(lessonRepositoryProvider)),
);
final listLessonsByModuleUseCaseProvider = Provider<ListLessonsByModuleUseCase>(
  (ref) => ListLessonsByModuleUseCase(ref.watch(lessonRepositoryProvider)),
);
final completeLessonUseCaseProvider = Provider<CompleteLessonUseCase>(
  (ref) => CompleteLessonUseCase(ref.watch(lessonRepositoryProvider)),
);

final lessonDetailProvider = FutureProvider.family<Lesson, String>((
  ref,
  id,
) async {
  final result = await ref.watch(getLessonUseCaseProvider).call(id);
  return result.fold((f) => throw f, (v) => v);
});

final lessonsByModuleProvider = FutureProvider.family<List<LessonMini>, String>(
  (ref, moduleId) async {
    final result = await ref
        .watch(listLessonsByModuleUseCaseProvider)
        .call(moduleId);
    return result.fold((f) => throw f, (v) => v);
  },
);
