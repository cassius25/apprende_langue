import 'package:flutter/material.dart';
import 'package:langapp/features/goals/domain/repositories/goal_repository.dart';

import '../../../../core/theme/app_colors.dart';

class DailyGoalCard extends StatelessWidget {
  const DailyGoalCard({super.key, this.goal, this.onSetGoal});
  final TodayGoal? goal;
  final VoidCallback? onSetGoal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (goal == null || goal!.target == 0) {
      return Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onSetGoal,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.flag_outlined, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Définir un objectif quotidien',
                    style: theme.textTheme.titleMedium,
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

    final unit = goal!.goal?.type.name == 'MINUTES' ? 'min' : 'mots';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Objectif du jour', style: theme.textTheme.titleMedium),
                const Spacer(),
                Text(
                  '${goal!.current} / ${goal!.target} $unit',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: goal!.progressPercent / 100,
                minHeight: 10,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(
                  goal!.achieved ? AppColors.success : AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              goal!.achieved
                  ? '🎉 Objectif atteint — bravo !'
                  : '${goal!.progressPercent.toStringAsFixed(0)} %',
              style: theme.textTheme.bodySmall?.copyWith(
                color: goal!.achieved
                    ? AppColors.success
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
