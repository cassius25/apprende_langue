import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/streak_remote_datasource.dart';
import '../../data/repositories/streak_repository_impl.dart';
import '../../domain/entities/streak.dart';
import '../../domain/repositories/streak_repository.dart';
import '../../domain/usecases/streak_usecases.dart';

final streakRemoteProvider = Provider<StreakRemoteDataSource>(
  (ref) => StreakRemoteDataSource(ref.watch(dioProvider)),
);

final streakRepositoryProvider = Provider<StreakRepository>((ref) {
  return StreakRepositoryImpl(
    remote: ref.watch(streakRemoteProvider),
    network: ref.watch(networkInfoProvider),
  );
});

final getStreakUseCaseProvider = Provider<GetStreakUseCase>(
  (ref) => GetStreakUseCase(ref.watch(streakRepositoryProvider)),
);
final getStreakCalendarUseCaseProvider = Provider<GetStreakCalendarUseCase>(
  (ref) => GetStreakCalendarUseCase(ref.watch(streakRepositoryProvider)),
);

final streakInfoProvider = FutureProvider<StreakInfo>((ref) async {
  final result = await ref.watch(getStreakUseCaseProvider).call();
  return result.fold((f) => throw f, (v) => v);
});

class CalendarQuery {
  const CalendarQuery({this.days = 30, this.offset = 0});
  final int days;
  final int offset;

  @override
  bool operator ==(Object other) =>
      other is CalendarQuery && other.days == days && other.offset == offset;
  @override
  int get hashCode => Object.hash(days, offset);
}

final streakCalendarProvider =
    FutureProvider.family<StreakCalendar, CalendarQuery>((ref, q) async {
      final result = await ref
          .watch(getStreakCalendarUseCaseProvider)
          .call(days: q.days, offset: q.offset);
      return result.fold((f) => throw f, (v) => v);
    });
