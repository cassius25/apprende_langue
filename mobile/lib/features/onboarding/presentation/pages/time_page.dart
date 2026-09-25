import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/onboarding_controller.dart';
import '../widgets/onboarding_scaffold.dart';

class TimePage extends ConsumerWidget {
  const TimePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onboardingControllerProvider);
    final theme = Theme.of(context);

    const options = [5, 10, 15, 20, 30];

    return OnboardingScaffold(
      step: 5,
      totalSteps: 7,
      title: 'Combien de temps par jour ?',
      subtitle: 'Prévoyez un moment réaliste pour vos sessions.',
      onBack: () => context.pop(),
      onNext: () => context.push('/onboarding/account'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final m in options)
                ChoiceChip(
                  label: Text('$m min'),
                  selected: data.dailyMinutes == m,
                  onSelected: (_) => ref
                      .read(onboardingControllerProvider.notifier)
                      .setDailyMinutes(m),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'La régularité compte plus que la durée. 10 minutes par jour suffisent '
                      'pour progresser visiblement en quelques semaines.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
