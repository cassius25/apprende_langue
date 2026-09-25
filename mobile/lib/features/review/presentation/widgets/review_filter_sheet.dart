import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../languages/presentation/providers/language_providers.dart';
import '../../domain/entities/review_session_config.dart';

/// Feuille modale pour régler la configuration de session.
/// Renvoie la config sélectionnée via `Navigator.pop`.
Future<ReviewSessionConfig?> showReviewFilterSheet(
  BuildContext context, {
  required ReviewSessionConfig initial,
}) {
  return showModalBottomSheet<ReviewSessionConfig>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ReviewFilterSheet(initial: initial),
  );
}

class _ReviewFilterSheet extends ConsumerStatefulWidget {
  const _ReviewFilterSheet({required this.initial});
  final ReviewSessionConfig initial;

  @override
  ConsumerState<_ReviewFilterSheet> createState() => _ReviewFilterSheetState();
}

class _ReviewFilterSheetState extends ConsumerState<_ReviewFilterSheet> {
  late ReviewSessionConfig _config;

  @override
  void initState() {
    super.initState();
    _config = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languagesAsync = ref.watch(allLanguagesProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Configurer la session', style: theme.textTheme.titleLarge),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ─── Langue ─────────────────────────────────────
          Text('Langue', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          languagesAsync.when(
            data: (langs) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Toutes'),
                  selected: _config.languageId == null,
                  onSelected: (_) => setState(
                    () => _config = _config.copyWith(clearLanguage: true),
                  ),
                ),
                for (final l in langs)
                  ChoiceChip(
                    label: Text('${l.flagEmoji ?? "🌐"} ${l.name}'),
                    selected: _config.languageId == l.id,
                    onSelected: (_) => setState(
                      () => _config = _config.copyWith(languageId: l.id),
                    ),
                  ),
              ],
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 20),

          // ─── Taille du lot ──────────────────────────────
          Text('Nombre de cartes', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final n in reviewBatchSizeOptions)
                ChoiceChip(
                  label: Text('$n'),
                  selected: _config.batchSize == n,
                  onSelected: (_) =>
                      setState(() => _config = _config.copyWith(batchSize: n)),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // ─── Options ────────────────────────────────────
          SwitchListTile.adaptive(
            value: _config.includeNew,
            onChanged: (v) =>
                setState(() => _config = _config.copyWith(includeNew: v)),
            title: const Text('Inclure de nouveaux mots'),
            subtitle: const Text('Ajoute des mots jamais vus à la session.'),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile.adaptive(
            value: _config.shuffle,
            onChanged: (v) =>
                setState(() => _config = _config.copyWith(shuffle: v)),
            title: const Text('Mélanger les cartes'),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),

          FilledButton(
            onPressed: () => Navigator.pop(context, _config),
            child: const Text('Appliquer'),
          ),
        ],
      ),
    );
  }
}
