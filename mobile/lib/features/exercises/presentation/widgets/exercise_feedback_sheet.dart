import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/exercise_result.dart';

/// Feuille de feedback affichée en bas d'écran après vérification.
class ExerciseFeedbackSheet extends StatelessWidget {
  const ExerciseFeedbackSheet({
    super.key,
    required this.correction,
    required this.onNext,
    required this.isLast,
  });

  final SubmitExerciseResult correction;
  final VoidCallback onNext;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ok = correction.isCorrect;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: (ok ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    ok ? Icons.check_rounded : Icons.close_rounded,
                    color: ok ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ok ? 'Bonne réponse !' : 'Réponse incorrecte',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: ok ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
                Text(
                  '+${correction.xpEarned} XP',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
            if (!ok && correction.correctAnswer != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Réponse attendue', style: theme.textTheme.labelSmall),
                    const SizedBox(height: 4),
                    Text(
                      correction.correctAnswer!,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
            if (correction.explanation != null &&
                correction.explanation!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  correction.explanation!,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onNext,
              child: Text(isLast ? 'Voir le résultat' : 'Exercice suivant'),
            ),
          ],
        ),
      ),
    );
  }
}
