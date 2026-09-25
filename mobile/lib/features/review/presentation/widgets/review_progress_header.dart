import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ReviewProgressHeader extends StatelessWidget {
  const ReviewProgressHeader({
    super.key,
    required this.current,
    required this.total,
    required this.correct,
    required this.wrong,
  });

  final int current;
  final int total;
  final int correct;
  final int wrong;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = total == 0 ? 0.0 : current / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Carte ${current + 1} / $total',
                style: theme.textTheme.titleSmall,
              ),
            ),
            _Pill(
              icon: Icons.check_rounded,
              label: '$correct',
              color: AppColors.success,
            ),
            const SizedBox(width: 6),
            _Pill(
              icon: Icons.close_rounded,
              label: '$wrong',
              color: AppColors.error,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
