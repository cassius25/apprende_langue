import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/statistics_remote_datasource.dart';
import '../../data/repositories/statistics_repository_impl.dart';
import '../../domain/entities/statistics.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../../domain/usecases/statistics_usecases.dart';

final statisticsRemoteProvider = Provider<StatisticsRemoteDataSource>(
  (ref) => StatisticsRemoteDataSource(ref.watch(dioProvider)),
);

final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  return StatisticsRepositoryImpl(
    remote: ref.watch(statisticsRemoteProvider),
    network: ref.watch(networkInfoProvider),
  );
});

final getOverviewStatsUseCaseProvider = Provider<GetOverviewStatsUseCase>(
  (ref) => GetOverviewStatsUseCase(ref.watch(statisticsRepositoryProvider)),
);
final getActivityChartUseCaseProvider = Provider<GetActivityChartUseCase>(
  (ref) => GetActivityChartUseCase(ref.watch(statisticsRepositoryProvider)),
);
final getSkillsUseCaseProvider = Provider<GetSkillsUseCase>(
  (ref) => GetSkillsUseCase(ref.watch(statisticsRepositoryProvider)),
);

final overviewStatsProvider = FutureProvider<OverviewStats>((ref) async {
  final result = await ref.watch(getOverviewStatsUseCaseProvider).call();
  return result.fold((f) => throw f, (v) => v);
});

class ActivityQuery {
  const ActivityQuery({this.days = 30, this.offset = 0});
  final int days;
  final int offset;

  @override
  bool operator ==(Object other) =>
      other is ActivityQuery && other.days == days && other.offset == offset;
  @override
  int get hashCode => Object.hash(days, offset);
}

final activityChartProvider =
    FutureProvider.family<ActivityChart, ActivityQuery>((ref, q) async {
      final result = await ref
          .watch(getActivityChartUseCaseProvider)
          .call(days: q.days, offset: q.offset);
      return result.fold((f) => throw f, (v) => v);
    });

final skillsProvider = FutureProvider<List<SkillProgress>>((ref) async {
  final result = await ref.watch(getSkillsUseCaseProvider).call();
  return result.fold((f) => throw f, (v) => v);
});
