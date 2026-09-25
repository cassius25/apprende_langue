import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:langapp/core/utils/result.dart';
import 'package:langapp/features/flashcards/domain/entities/flashcard.dart';
import 'package:langapp/features/flashcards/presentation/providers/flashcards_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_vocabulary_entry.dart';
import '../providers/vocabulary_providers.dart';

class VocabularyDetailPage extends ConsumerWidget {
  const VocabularyDetailPage({super.key, required this.vocabularyId});
  final String vocabularyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(vocabularyDetailProvider(vocabularyId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: async.when(
        data: (item) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(item.word, style: theme.textTheme.displaySmall),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${item.languageFlagEmoji ?? ''} ${item.languageName}'
                        .trim(),
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ],
            ),
            if (item.phonetic != null) ...[
              const SizedBox(height: 4),
              Text(
                item.phonetic!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (item.translations.isNotEmpty) ...[
              Text('Traductions', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final t in item.translations)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        '${t.languageName} : ',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Expanded(
                        child: Text(
                          t.translation,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            if (item.examples.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Exemples', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final e in item.examples)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.sentence, style: theme.textTheme.bodyLarge),
                        if (e.translation != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              e.translation!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () async {
                final result = await ref
                    .read(startLearningUseCaseProvider)
                    .call(item.id);
                if (!context.mounted) return;
                if (result.isRight()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mot ajouté à votre liste.')),
                  );
                  ref.invalidate(dueVocabularyListProvider);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result.failureOrNull!.message)),
                  );
                }
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Apprendre ce mot'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                // Démarre une session avec uniquement ce mot.
                final result = await ref
                    .read(startLearningUseCaseProvider)
                    .call(item.id);
                if (!context.mounted) return;
                if (result.isRight()) {
                  final session = ref.read(
                    flashcardsControllerProvider.notifier,
                  );
                  await session.startCustom(
                    result.valueOrNull == null
                        ? []
                        : [Flashcard(entry: result.valueOrNull!)],
                  );
                  if (!context.mounted) return;
                  await context.push('/learn/flashcards');
                }
              },
              icon: const Icon(Icons.style_rounded),
              label: const Text('Réviser en flashcard'),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}

// Evite l'avertissement d'import inutilisé pour UserVocabularyEntry.
// ignore: unused_element
UserVocabularyEntry? _unused;
