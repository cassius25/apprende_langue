import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/profile_providers.dart';

/// Catalogue local des badges (statique, miroir du seed backend).
class _BadgeDef {
  const _BadgeDef(this.code, this.name, this.description, this.icon);
  final String code;
  final String name;
  final String description;
  final String icon;
}

const _catalog = [
  _BadgeDef(
    'FIRST_LESSON',
    'Première leçon',
    'Terminer sa première leçon',
    '🏆',
  ),
  _BadgeDef(
    'STREAK_7',
    '7 jours consécutifs',
    'Apprendre 7 jours de suite',
    '🔥',
  ),
  _BadgeDef(
    'STREAK_30',
    '30 jours consécutifs',
    'Apprendre 30 jours de suite',
    '🔥',
  ),
  _BadgeDef('WORDS_100', '100 mots appris', 'Apprendre 100 mots', '📚'),
  _BadgeDef(
    'EXERCISES_100',
    '100 exercices réussis',
    'Réussir 100 exercices',
    '🎯',
  ),
  _BadgeDef(
    'FIRST_LANGUAGE',
    'Polyglotte débutant',
    'Commencer 3 langues',
    '🌍',
  ),
];

class BadgesPage extends ConsumerWidget {
  const BadgesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(badgesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Badges')),
      body: SafeArea(
        child: badgesAsync.when(
          data: (earned) {
            final earnedMap = {for (final b in earned) b.code: b};
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Badges gagnés : ${earned.where((b) => b.earned).length} / ${_catalog.length}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                for (final def in _catalog)
                  _BadgeTile(def: def, earnedAt: earnedMap[def.code]?.earnedAt),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
        ),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.def, this.earnedAt});
  final _BadgeDef def;
  final DateTime? earnedAt;

  @override
  Widget build(BuildContext context) {
    final earned = earnedAt != null;
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Opacity(
          opacity: earned ? 1 : 0.35,
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (earned ? AppColors.secondary : AppColors.textMuted)
                  .withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text(def.icon, style: const TextStyle(fontSize: 22)),
          ),
        ),
        title: Text(def.name),
        subtitle: Text(
          earned
              ? 'Obtenu le ${earnedAt!.day}/${earnedAt!.month}/${earnedAt!.year}'
              : def.description,
          style: theme.textTheme.bodySmall,
        ),
        trailing: earned
            ? const Icon(Icons.check_circle_rounded, color: AppColors.success)
            : const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.textMuted,
              ),
      ),
    );
  }
}
