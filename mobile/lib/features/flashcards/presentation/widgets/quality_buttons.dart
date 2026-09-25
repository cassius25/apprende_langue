import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Les 4 boutons de qualité SM-2 demandés au §8 :
/// ❌ Je ne connais pas (1) — 😐 Difficile (3) — 🙂 Facile (4) — ✅ Je connais (5).
class QualityButtons extends StatelessWidget {
  const QualityButtons({
    super.key,
    required this.onSelect,
    this.enabled = true,
  });

  final void Function(int quality) onSelect;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QualityButton(
          emoji: '❌',
          label: 'Je ne connais pas',
          color: AppColors.error,
          quality: 1,
          onSelect: onSelect,
          enabled: enabled,
        ),
        const SizedBox(width: 8),
        _QualityButton(
          emoji: '😐',
          label: 'Difficile',
          color: AppColors.warning,
          quality: 3,
          onSelect: onSelect,
          enabled: enabled,
        ),
        const SizedBox(width: 8),
        _QualityButton(
          emoji: '🙂',
          label: 'Facile',
          color: AppColors.info,
          quality: 4,
          onSelect: onSelect,
          enabled: enabled,
        ),
        const SizedBox(width: 8),
        _QualityButton(
          emoji: '✅',
          label: 'Je connais',
          color: AppColors.success,
          quality: 5,
          onSelect: onSelect,
          enabled: enabled,
        ),
      ],
    );
  }
}

class _QualityButton extends StatelessWidget {
  const _QualityButton({
    required this.emoji,
    required this.label,
    required this.color,
    required this.quality,
    required this.onSelect,
    required this.enabled,
  });

  final String emoji;
  final String label;
  final Color color;
  final int quality;
  final void Function(int) onSelect;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: enabled ? () => onSelect(quality) : null,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
