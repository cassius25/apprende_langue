import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../providers/home_providers.dart';
import '../widgets/daily_goal_card.dart';
import '../widgets/streak_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final snapAsync = ref.watch(dashboardSnapshotProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LangApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(dashboardSnapshotProvider),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Bonjour${user != null ? " ${user.firstName}" : ""} !',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Prêt à progresser aujourd’hui ?',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              snapAsync.when(
                data: (snap) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StreakCard(
                      current: snap.streakCurrent,
                      longest: snap.streakLongest,
                    ),
                    const SizedBox(height: 12),
                    DailyGoalCard(
                      goal: snap.todayGoal,
                      onSetGoal: () => context.push('/goals'),
                    ),
                    const SizedBox(height: 12),
                    _ContinueCard(
                      lessonId: snap.continueLessonId,
                      lessonTitle: snap.continueLessonTitle,
                    ),
                    const SizedBox(height: 12),
                    _DueCard(count: snap.dueCount),
                    const SizedBox(height: 12),
                    _ProgressCard(
                      xp: snap.totalXp,
                      level: snap.userLevel,
                      completed: snap.lessonsCompleted,
                    ),
                    const SizedBox(height: 12),
                    _QuickLinks(),
                  ],
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Erreur de chargement : $e'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({this.lessonId, this.lessonTitle});
  final String? lessonId;
  final String? lessonTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasLesson = lessonId != null;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: hasLesson
            ? () => context.push('/learn/lessons/$lessonId')
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.play_circle_outline_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Continuer l’apprentissage',
                      style: theme.textTheme.labelMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasLesson ? lessonTitle! : 'Choisissez une leçon',
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (hasLesson)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DueCard extends StatelessWidget {
  const _DueCard({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/learn/flashcards'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'À réviser aujourd’hui',
                      style: theme.textTheme.labelMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      count == 0
                          ? 'Rien à réviser pour l’instant'
                          : '$count mot${count == 1 ? "" : "s"}',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.xp,
    required this.level,
    required this.completed,
  });

  final int xp;
  final int level;
  final int completed;

  @override
  Widget build(BuildContext context) {
    const xpPerLevel = 200;
    final xpInLevel = xp % xpPerLevel;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Niveau $level', style: theme.textTheme.titleMedium),
                const Spacer(),
                Text(
                  '$xpInLevel / $xpPerLevel XP',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: xpInLevel / xpPerLevel,
                minHeight: 10,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$completed leçon${completed == 1 ? "" : "s"} terminée${completed == 1 ? "" : "s"}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickLink(
            icon: Icons.style_rounded,
            label: 'Flashcards',
            color: AppColors.primary,
            onTap: () => context.push('/learn/flashcards'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickLink(
            icon: Icons.book_outlined,
            label: 'Vocabulaire',
            color: AppColors.accent,
            onTap: () => context.push('/learn/vocabulary'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickLink(
            icon: Icons.school_outlined,
            label: 'Cours',
            color: AppColors.secondary,
            onTap: () => context.push('/learn/courses'),
          ),
        ),
      ],
    );
  }
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
