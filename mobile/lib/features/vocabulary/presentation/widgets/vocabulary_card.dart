import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/vocabulary_item.dart';

class VocabularyCard extends StatelessWidget {
  const VocabularyCard({
    super.key,
    required this.item,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteToggle,
  });

  final VocabularyItem item;
  final bool isFavorite;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final translation = item.translations.isNotEmpty
        ? item.translations.first.translation
        : '';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.languageFlagEmoji ?? '🌐',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.word, style: theme.textTheme.titleMedium),
                    if (item.phonetic != null)
                      Text(
                        item.phonetic!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    if (translation.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        translation,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onFavoriteToggle != null)
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                    color: isFavorite
                        ? AppColors.secondary
                        : AppColors.textMuted,
                  ),
                  onPressed: () => onFavoriteToggle!(!isFavorite),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
