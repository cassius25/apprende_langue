import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../vocabulary/presentation/providers/vocabulary_providers.dart';
import '../providers/review_providers.dart';
import '../providers/review_session_controller.dart';

class ReviewSummaryPage extends ConsumerWidget {
  const ReviewSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reviewSessionControllerProvider);
    final stats = state.stats;
    final theme = Theme.of(context);

    if (stats == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final avgSec = (stats.averageResponseMs / 1000).toStringAsFixed(1);
    final goodStreak = stats.successPercent >= 70;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _exit(context, ref);
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: (goodStreak ? AppColors.success : AppColors.warning)
                        .withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${stats.successPercent}%',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: goodStreak ? AppColors.success : AppColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Session terminée !',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${stats.correct} / ${stats.answered} bonnes réponses',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              if (stats.offlineQueued)
                Card(
                  color: AppColors.warning.withValues(alpha: 0.08),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.cloud_off_rounded,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Session enregistrée hors ligne. '
                            'Elle sera synchronisée automatiquement.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (stats.offlineQueued) const SizedBox(height: 16),

              // ─── Stats ──────────────────────────────────
              _StatRow(label: 'XP gagné', value: '+${stats.xpEarned} XP'),
              _StatRow(
                label: 'Score moyen',
                value: '${stats.successPercent} / 100',
              ),
              _StatRow(
                label: 'Qualité moyenne',
                value: '${stats.averageQuality.toStringAsFixed(1)} / 5',
              ),
              _StatRow(label: 'Temps de réponse moyen', value: '$avgSec s'),
              if (stats.streakCurrent > 0)
                _StatRow(
                  label: 'Série',
                  value: '🔥 ${stats.streakCurrent} jours',
                ),

              // ─── Badges ─────────────────────────────────
              if (stats.newBadges.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text('Nouveaux badges', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                for (final b in stats.newBadges)
                  Card(
                    child: ListTile(
                      leading: Text(
                        b.icon ?? '🏆',
                        style: const TextStyle(fontSize: 28),
                      ),
                      title: Text(b.name),
                    ),
                  ),
              ],

              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => _exit(context, ref),
                child: const Text('Terminer'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  ref.read(reviewSessionControllerProvider.notifier).reset();
                  context.go('/review');
                },
                child: const Text('Nouvelle session'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exit(BuildContext context, WidgetRef ref) {
    ref.read(reviewSessionControllerProvider.notifier).reset();
    ref.invalidate(dashboardSnapshotProvider);
    ref.invalidate(dueVocabularyCountProvider);
    ref.invalidate(dueReviewCountProvider);
    ref.invalidate(reviewQueueSummaryProvider);
    context.goNamed(RouteNames.review);
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
