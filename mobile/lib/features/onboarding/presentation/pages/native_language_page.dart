import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../languages/presentation/providers/language_providers.dart';
import '../../../languages/presentation/widgets/language_card.dart';
import '../providers/onboarding_controller.dart';
import '../widgets/onboarding_scaffold.dart';

class NativeLanguagePage extends ConsumerWidget {
  const NativeLanguagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(allLanguagesProvider);
    final data = ref.watch(onboardingControllerProvider);

    return OnboardingScaffold(
      step: 1,
      totalSteps: 7,
      title: 'Quelle est votre langue maternelle ?',
      subtitle: 'Elle nous aide à personnaliser votre apprentissage.',
      onBack: () => context.pop(),
      nextEnabled: data.nativeLanguageId != null,
      onNext: () => context.push('/onboarding/learning'),
      child: async.when(
        data: (langs) => ListView.separated(
          itemCount: langs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final l = langs[i];
            return LanguageCard(
              language: l,
              selected: data.nativeLanguageId == l.id,
              onTap: () => ref
                  .read(onboardingControllerProvider.notifier)
                  .setNativeLanguage(l.id),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
