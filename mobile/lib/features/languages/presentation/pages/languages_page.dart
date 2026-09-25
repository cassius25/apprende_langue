import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../providers/language_providers.dart';
import '../widgets/language_card.dart';

/// Écran « Apprendre → Langues » : liste les langues disponibles et
/// permet de naviguer vers les cours de chaque langue.
class LanguagesPage extends ConsumerWidget {
  const LanguagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(allLanguagesProvider);
    final active = ref.watch(activeLanguageIdProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Langues')),
      body: async.when(
        data: (languages) {
          if (languages.isEmpty) {
            return const Center(child: Text('Aucune langue disponible.'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(allLanguagesProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: languages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final l = languages[i];
                return LanguageCard(
                  language: l,
                  selected: l.id == active,
                  onTap: () =>
                      context.push('/learn/courses?languageId=${l.id}'),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: 8),
              Text('$e'),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => ref.invalidate(allLanguagesProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
