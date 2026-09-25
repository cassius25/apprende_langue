import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/onboarding_data.dart';
import '../providers/onboarding_controller.dart';
import '../widgets/onboarding_scaffold.dart';

class GoalPage extends ConsumerWidget {
  const GoalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onboardingControllerProvider);
    final theme = Theme.of(context);

    const minuteTargets = [5, 10, 15, 20, 30];
    const wordTargets = [5, 10, 20, 30, 50];

    return OnboardingScaffold(
      step: 4,
      totalSteps: 7,
      title: 'Votre objectif quotidien',
      subtitle:
          'Choisissez un objectif atteignable — vous pourrez le modifier.',
      onBack: () => context.pop(),
      onNext: () => context.push('/onboarding/time'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<OnboardingGoalType>(
            segments: const [
              ButtonSegment(
                value: OnboardingGoalType.minutes,
                label: Text('Minutes'),
                icon: Icon(Icons.timer_outlined),
              ),
              ButtonSegment(
                value: OnboardingGoalType.words,
                label: Text('Mots'),
                icon: Icon(Icons.abc_rounded),
              ),
            ],
            selected: {data.goalType},
            onSelectionChanged: (s) {
              final type = s.first;
              ref
                  .read(onboardingControllerProvider.notifier)
                  .setGoal(
                    type: type,
                    target: type == OnboardingGoalType.minutes ? 10 : 10,
                  );
            },
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final t
                  in data.goalType == OnboardingGoalType.minutes
                      ? minuteTargets
                      : wordTargets)
                ChoiceChip(
                  label: Text('$t'),
                  selected: data.goalTarget == t,
                  onSelected: (_) {
                    ref
                        .read(onboardingControllerProvider.notifier)
                        .setGoal(type: data.goalType, target: t);
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Objectif sélectionné : ${data.goalTarget} '
            '${data.goalType == OnboardingGoalType.minutes ? "minutes" : "mots"} par jour',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
