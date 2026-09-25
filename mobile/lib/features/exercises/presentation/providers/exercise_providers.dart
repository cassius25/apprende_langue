import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/drift/providers.dart';
import '../../data/datasources/exercise_local_datasource.dart';
import '../../data/datasources/exercise_remote_datasource.dart';
import '../../data/repositories/exercise_repository_impl.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../../domain/usecases/exercise_usecases.dart';

final exerciseRemoteProvider = Provider<ExerciseRemoteDataSource>(
  (ref) => ExerciseRemoteDataSource(ref.watch(dioProvider)),
);

final exerciseLocalProvider = Provider<ExerciseLocalDataSource>(
  (ref) => ExerciseLocalDataSource(ref.watch(appDatabaseProvider)),
);

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  return ExerciseRepositoryImpl(
    remote: ref.watch(exerciseRemoteProvider),
    local: ref.watch(exerciseLocalProvider),
    network: ref.watch(networkInfoProvider),
  );
});

final listExercisesForLessonUseCaseProvider =
    Provider<ListExercisesForLessonUseCase>(
      (ref) =>
          ListExercisesForLessonUseCase(ref.watch(exerciseRepositoryProvider)),
    );

final submitExerciseUseCaseProvider = Provider<SubmitExerciseUseCase>(
  (ref) => SubmitExerciseUseCase(ref.watch(exerciseRepositoryProvider)),
);

/// Liste des exercices d'une leçon (utilisée pour les compteurs).
final lessonExercisesProvider = FutureProvider.family<List<Exercise>, String>((
  ref,
  lessonId,
) async {
  final result = await ref
      .watch(listExercisesForLessonUseCaseProvider)
      .call(lessonId);
  return result.fold((f) => throw f, (v) => v);
});
