import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/onboarding_controller.dart';
import '../widgets/onboarding_scaffold.dart';

class _LevelOption {
  const _LevelOption(this.code, this.label, this.description);
  final String code;
  final String label;
  final String description;
}

const _levels = [
  _LevelOption('A1', 'Débutant', 'Je découvre la langue.'),
  _LevelOption('A2', 'Élémentaire', 'Je peux tenir une conversation simple.'),
  _LevelOption(
    'B1',
    'Intermédiaire',
    'Je comprends et m’exprime sur des sujets familiers.',
  ),
  _LevelOption('B2', 'Avancé', 'Je communique avec aisance.'),
  _LevelOption(
    'C1',
    'Autonome',
    'Je m’exprime spontanément et avec précision.',
  ),
  _LevelOption('C2', 'Maîtrise', 'Je maîtrise la langue à un niveau natif.'),
];

class LevelPage extends ConsumerWidget {
  const LevelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onboardingControllerProvider);
    final theme = Theme.of(context);

    return OnboardingScaffold(
      step: 3,
      totalSteps: 7,
      title: 'Où en êtes-vous ?',
      subtitle: 'Une estimation suffit — vous pourrez ajuster plus tard.',
      onBack: () => context.pop(),
      nextEnabled: data.estimatedLevelCode != null,
      onNext: () => context.push('/onboarding/goal'),
      child: ListView.separated(
        itemCount: _levels.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final l = _levels[i];
          final selected = data.estimatedLevelCode == l.code;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: selected ? AppColors.primary : AppColors.border,
                width: selected ? 2 : 1,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => ref
                  .read(onboardingControllerProvider.notifier)
                  .setEstimatedLevel(l.code),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        l.code,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.label, style: theme.textTheme.titleMedium),
                          Text(
                            l.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primary,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
