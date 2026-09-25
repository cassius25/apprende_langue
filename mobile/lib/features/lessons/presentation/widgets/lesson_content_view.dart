import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/lesson.dart';

class LessonContentView extends StatelessWidget {
  const LessonContentView({super.key, required this.content});
  final LessonContent content;

  @override
  Widget build(BuildContext context) {
    switch (content.type) {
      case LessonContentType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            content.content,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const _BrokenMedia(
              icon: Icons.broken_image_outlined,
              label: 'Image indisponible',
            ),
          ),
        );
      case LessonContentType.audio:
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.audiotrack_rounded, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  content.content.split('/').last,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Icon(Icons.play_arrow_rounded, color: AppColors.primary),
            ],
          ),
        );
      case LessonContentType.video:
        return Container(
          height: 180,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.play_circle_outline_rounded,
            size: 56,
            color: AppColors.primary,
          ),
        );
      case LessonContentType.markdown:
        return _SimpleMarkdown(content.content);
      case LessonContentType.text:
        return Text(
          content.content,
          style: Theme.of(context).textTheme.bodyLarge,
        );
    }
  }
}

/// Rendu markdown minimaliste (gras, italique, titres, listes).
/// Pas de dépendance supplémentaire — suffisant pour le contenu pédagogique.
class _SimpleMarkdown extends StatelessWidget {
  const _SimpleMarkdown(this.raw);
  final String raw;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lines = raw.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }
      if (trimmed.startsWith('### ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              trimmed.substring(4),
              style: theme.textTheme.titleMedium,
            ),
          ),
        );
      } else if (trimmed.startsWith('## ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              trimmed.substring(3),
              style: theme.textTheme.titleLarge,
            ),
          ),
        );
      } else if (trimmed.startsWith('# ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Text(
              trimmed.substring(2),
              style: theme.textTheme.headlineSmall,
            ),
          ),
        );
      } else if (trimmed.startsWith('- ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•  '),
                Expanded(child: _inline(trimmed.substring(2), theme)),
              ],
            ),
          ),
        );
      } else {
        widgets.add(_inline(trimmed, theme));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _inline(String text, ThemeData theme) {
    // Support basique de **gras** uniquement.
    final parts = text.split('**');
    if (parts.length == 1) {
      return Text(text, style: theme.textTheme.bodyLarge);
    }
    final spans = <TextSpan>[];
    for (var i = 0; i < parts.length; i++) {
      final isBold = i.isOdd;
      spans.add(
        TextSpan(
          text: parts[i],
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      );
    }
    return RichText(text: TextSpan(children: spans));
  }
}

class _BrokenMedia extends StatelessWidget {
  const _BrokenMedia({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textMuted),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
