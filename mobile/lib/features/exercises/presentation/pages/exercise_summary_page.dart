import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../vocabulary/presentation/providers/vocabulary_providers.dart';
import '../providers/exercise_session_controller.dart';

class ExerciseSummaryPage extends ConsumerWidget {
  const ExerciseSummaryPage({super.key, required this.state});
  final ExerciseSessionState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final total = state.total;
    final correct = state.correctCount;
    final percent = state.overallScore;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        ref.read(exerciseSessionControllerProvider.notifier).reset();
        ref.invalidate(dashboardSnapshotProvider);
        ref.invalidate(dueVocabularyCountProvider);
        if (context.mounted) context.goNamed(RouteNames.home);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 120,
                  height: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        (percent >= 70 ? AppColors.success : AppColors.warning)
                            .withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$percent%',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: percent >= 70
                          ? AppColors.success
                          : AppColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Session terminée !',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '$correct / $total bonnes réponses',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                _StatRow(label: 'XP gagné', value: '+${state.xpEarned} XP'),
                _StatRow(label: 'Score moyen', value: '$percent / 100'),
                _StatRow(label: 'Bonnes réponses', value: '$correct'),
                _StatRow(label: 'À revoir', value: '${total - correct}'),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    ref
                        .read(exerciseSessionControllerProvider.notifier)
                        .reset();
                    ref.invalidate(dashboardSnapshotProvider);
                    ref.invalidate(dueVocabularyCountProvider);
                    context.goNamed(RouteNames.home);
                  },
                  child: const Text('Terminer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
