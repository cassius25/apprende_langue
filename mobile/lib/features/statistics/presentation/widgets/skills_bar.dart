import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/statistics.dart';

class SkillsBar extends StatelessWidget {
  const SkillsBar({super.key, required this.skills});
  final List<SkillProgress> skills;

  static const _labels = {
    'VOCABULARY': 'Vocabulaire',
    'GRAMMAR': 'Grammaire',
    'LISTENING': 'Écoute',
    'READING': 'Lecture',
    'SPEAKING': 'Parler',
    'WRITING': 'Écrire',
  };

  static const _icons = {
    'VOCABULARY': Icons.menu_book_outlined,
    'GRAMMAR': Icons.rule_outlined,
    'LISTENING': Icons.headphones_outlined,
    'READING': Icons.article_outlined,
    'SPEAKING': Icons.mic_none_outlined,
    'WRITING': Icons.edit_note_outlined,
  };

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return const Text('Aucune donnée de compétence pour le moment.');
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progression par compétence',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            for (final s in skills)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(
                      _icons[s.skill] ?? Icons.circle_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 90,
                      child: Text(
                        _labels[s.skill] ?? s.skill,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: s.progressPercent / 100,
                          minHeight: 8,
                          backgroundColor: AppColors.divider,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 44,
                      child: Text(
                        '${s.progressPercent.toStringAsFixed(0)}%',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
