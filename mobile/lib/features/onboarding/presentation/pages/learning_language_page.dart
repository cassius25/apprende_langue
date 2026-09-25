import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../languages/presentation/providers/language_providers.dart';
import '../../../languages/presentation/widgets/language_card.dart';
import '../providers/onboarding_controller.dart';
import '../widgets/onboarding_scaffold.dart';

class LearningLanguagePage extends ConsumerWidget {
  const LearningLanguagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(allLanguagesProvider);
    final data = ref.watch(onboardingControllerProvider);

    return OnboardingScaffold(
      step: 2,
      totalSteps: 7,
      title: 'Quelle langue voulez-vous apprendre ?',
      subtitle: 'Vous pourrez en ajouter d’autres plus tard.',
      onBack: () => context.pop(),
      nextEnabled:
          data.learningLanguageId != null &&
          data.learningLanguageId != data.nativeLanguageId,
      onNext: () => context.push('/onboarding/level'),
      child: async.when(
        data: (langs) {
          final filtered = langs
              .where((l) => l.id != data.nativeLanguageId)
              .toList();
          return ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final l = filtered[i];
              return LanguageCard(
                language: l,
                selected: data.learningLanguageId == l.id,
                onTap: () => ref
                    .read(onboardingControllerProvider.notifier)
                    .setLearningLanguage(l.id),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
