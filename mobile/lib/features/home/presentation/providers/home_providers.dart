import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:langapp/core/providers/core_providers.dart';
import 'package:langapp/features/goals/domain/repositories/goal_repository.dart';

import '../../../../core/storage/drift/app_database.dart';
import '../../../../core/storage/drift/providers.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../goals/presentation/providers/goals_providers.dart';
import '../../../lessons/presentation/providers/lesson_providers.dart';
import '../../../vocabulary/presentation/providers/vocabulary_providers.dart';

// ─────────────────────────────────────────────────────────────
// Snapshot du dashboard (agrège plusieurs sources locales + remote)
// ─────────────────────────────────────────────────────────────

class DashboardSnapshot {
  const DashboardSnapshot({
    this.streakCurrent = 0,
    this.streakLongest = 0,
    this.dueCount = 0,
    this.todayGoal,
    this.totalXp = 0,
    this.userLevel = 1,
    this.lessonsCompleted = 0,
    this.lessonsTotal = 0,
    this.continueLessonId,
    this.continueLessonTitle,
    this.continueCourseTitle,
  });

  final int streakCurrent;
  final int streakLongest;
  final int dueCount;
  final TodayGoal? todayGoal;
  final int totalXp;
  final int userLevel;
  final int lessonsCompleted;
  final int lessonsTotal;
  final String? continueLessonId;
  final String? continueLessonTitle;
  final String? continueCourseTitle;

  DashboardSnapshot copyWith({
    int? streakCurrent,
    int? streakLongest,
    int? dueCount,
    TodayGoal? todayGoal,
    int? totalXp,
    int? userLevel,
    int? lessonsCompleted,
    int? lessonsTotal,
    String? continueLessonId,
    String? continueLessonTitle,
    String? continueCourseTitle,
  }) {
    return DashboardSnapshot(
      streakCurrent: streakCurrent ?? this.streakCurrent,
      streakLongest: streakLongest ?? this.streakLongest,
      dueCount: dueCount ?? this.dueCount,
      todayGoal: todayGoal ?? this.todayGoal,
      totalXp: totalXp ?? this.totalXp,
      userLevel: userLevel ?? this.userLevel,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      lessonsTotal: lessonsTotal ?? this.lessonsTotal,
      continueLessonId: continueLessonId ?? this.continueLessonId,
      continueLessonTitle: continueLessonTitle ?? this.continueLessonTitle,
      continueCourseTitle: continueCourseTitle ?? this.continueCourseTitle,
    );
  }
}

final dashboardSnapshotProvider = FutureProvider<DashboardSnapshot>((
  ref,
) async {
  final db = ref.watch(appDatabaseProvider);
  final tokens = ref.watch(secureTokenStorageProvider);
  final userId = await tokens.readUserId();

  // 1) Streak (local)
  final streak = await db.userDao.getStreak();

  // 2) Due count (local)
  final dueCount = userId == null
      ? 0
      : await db.vocabularyDao.countDueForReview(userId);

  // 3) Goal (remote, avec fallback silencieux)
  TodayGoal? goal;
  try {
    goal = await ref.watch(todayGoalProvider.future);
  } catch (_) {
    goal = null;
  }

  // 4) User XP
  final user = ref.watch(currentUserProvider);

  // 5) Lessons completed/total (local + catalogue)
  final completed = userId == null
      ? 0
      : await db.progressDao.countCompleted(userId);

  // 6) Continue learning : dernière leçon IN_PROGRESS, sinon première NOT_STARTED
  String? lessonId;
  String? lessonTitle;
  String? courseTitle;
  if (userId != null) {
    final all = await db.progressDao.getByUser(userId);
    final inProgress = all.where((p) => p.status == 'IN_PROGRESS').toList()
      ..sort((a, b) => b.serverUpdatedAt.compareTo(a.serverUpdatedAt));
    if (inProgress.isNotEmpty) {
      final p = inProgress.first;
      final lesson = await db.catalogDao.getLessonById(p.lessonId);
      if (lesson != null) {
        lessonId = lesson.id;
        lessonTitle = lesson.title;
        courseTitle = '';
      }
    }
  }

  return DashboardSnapshot(
    streakCurrent: streak?.currentStreak ?? 0,
    streakLongest: streak?.longestStreak ?? 0,
    dueCount: dueCount,
    todayGoal: goal,
    totalXp: user?.xp ?? 0,
    userLevel: user?.userLevel ?? 1,
    lessonsCompleted: completed,
    lessonsTotal: 0,
    continueLessonId: lessonId,
    continueLessonTitle: lessonTitle,
    continueCourseTitle: courseTitle,
  );
});

/// ID de la langue active (première langue apprise) — utilisé par l'écran Languages.
final activeLanguageIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.nativeLanguageId;
});

// Providers de commodité
final dueCountProvider = FutureProvider<int>((ref) async {
  final snap = await ref.watch(dashboardSnapshotProvider.future);
  return snap.dueCount;
});

/// Petit wrapper pour exposer un `Drift` typé (utilisé par les widgets).
typedef AppDb = AppDatabase;

// évite les imports inutilisés
// ignore: unused_element
void _keep(WidgetRef ref) {
  ref.read(lessonRepositoryProvider);
  ref.read(dueVocabularyCountProvider);
}
