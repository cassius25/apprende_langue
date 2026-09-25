import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/goal_remote_datasource.dart';
import '../../data/repositories/goal_repository_impl.dart';
import '../../domain/entities/daily_goal.dart';
import '../../domain/repositories/goal_repository.dart';
import '../../domain/usecases/goal_usecases.dart';

// ─── Data ────────────────────────────────────────────────
final goalRemoteProvider = Provider<GoalRemoteDataSource>(
  (ref) => GoalRemoteDataSource(ref.watch(dioProvider)),
);

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepositoryImpl(
    remote: ref.watch(goalRemoteProvider),
    network: ref.watch(networkInfoProvider),
  );
});

// ─── Use cases ───────────────────────────────────────────
final listGoalsUseCaseProvider = Provider<ListGoalsUseCase>(
  (ref) => ListGoalsUseCase(ref.watch(goalRepositoryProvider)),
);
final todayGoalUseCaseProvider = Provider<TodayGoalUseCase>(
  (ref) => TodayGoalUseCase(ref.watch(goalRepositoryProvider)),
);
final upsertGoalUseCaseProvider = Provider<UpsertGoalUseCase>(
  (ref) => UpsertGoalUseCase(ref.watch(goalRepositoryProvider)),
);
final updateGoalUseCaseProvider = Provider<UpdateGoalUseCase>(
  (ref) => UpdateGoalUseCase(ref.watch(goalRepositoryProvider)),
);
final removeGoalUseCaseProvider = Provider<RemoveGoalUseCase>(
  (ref) => RemoveGoalUseCase(ref.watch(goalRepositoryProvider)),
);

// ─── Providers réactifs ──────────────────────────────────
final todayGoalProvider = FutureProvider<TodayGoal?>((ref) async {
  final result = await ref.watch(todayGoalUseCaseProvider).call();
  return result.fold((_) => null, (v) => v);
});

final allGoalsProvider = FutureProvider<List<DailyGoal>>((ref) async {
  final result = await ref.watch(listGoalsUseCaseProvider).call();
  return result.fold((f) => throw f, (v) => v);
});
