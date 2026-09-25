import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../flashcards/domain/entities/flashcard.dart';

/// Aperçu de la file de révision (sans révéler les réponses).
class ReviewQueuePreview extends StatelessWidget {
  const ReviewQueuePreview({super.key, required this.cards, this.max = 10});
  final List<Flashcard> cards;
  final int max;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final shown = cards.take(max).toList(growable: false);
    final remaining = cards.length - shown.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Aperçu de la file', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: shown.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final c = shown[i];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.border),
                ),
                alignment: Alignment.center,
                child: Text(
                  c.front,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
        ),
        if (remaining > 0) ...[
          const SizedBox(height: 6),
          Text(
            '… et $remaining autre${remaining == 1 ? "" : "s"}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}
