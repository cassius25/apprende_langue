import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';

/// Dashboard placeholder — sera remplacé en Parties 14-18 par :
/// - Continuer la leçon
/// - À réviser aujourd'hui
/// - Objectif du jour (avec progression)
/// - Série (streak)
/// - Progression globale
/// - Badges
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LangApp'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Bonjour !', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(
              'Prêt à apprendre une nouvelle langue ?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            const _PlaceholderCard(
              title: 'Continuer l’apprentissage',
              subtitle: 'Reprenez votre dernière leçon',
              icon: Icons.play_circle_outline_rounded,
            ),
            const SizedBox(height: 12),
            const _PlaceholderCard(
              title: 'À réviser aujourd’hui',
              subtitle: '0 mots à réviser',
              icon: Icons.refresh_rounded,
            ),
            const SizedBox(height: 12),
            const _PlaceholderCard(
              title: 'Objectif du jour',
              subtitle: 'Définissez votre objectif',
              icon: Icons.flag_outlined,
            ),
            const SizedBox(height: 12),
            const _PlaceholderCard(
              title: 'Progression',
              subtitle: 'Voir vos statistiques',
              icon: Icons.insights_outlined,
            ),
            const SizedBox(height: 24),
            Text(
              'Les fonctionnalités complètes arrivent dans les prochaines parties.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
