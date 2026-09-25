import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/streak.dart';

/// Calendrier de type contribution : une grille de jours colorés.
/// Affiche les `CalendarDay` fournis par le backend.
class StreakCalendarWidget extends StatelessWidget {
  const StreakCalendarWidget({
    super.key,
    required this.calendar,
    this.onPrevious,
    this.onNext,
  });

  final StreakCalendar calendar;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = calendar.days;

    // Regroupe par semaine (7 jours, lundi → dimanche).
    final weeks = <List<CalendarDay>>[];
    List<CalendarDay> current = [];
    for (final d in days) {
      current.add(d);
      if (current.length == 7) {
        weeks.add(current);
        current = [];
      }
    }
    if (current.isNotEmpty) weeks.add(current);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Activité', style: theme.textTheme.titleMedium),
                const Spacer(),
                if (onPrevious != null)
                  IconButton(
                    onPressed: onPrevious,
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                if (onNext != null)
                  IconButton(
                    onPressed: onNext,
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final l in ['L', 'M', 'M', 'J', 'V', 'S', 'D'])
                  Expanded(
                    child: Text(
                      l,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            for (final week in weeks)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    for (var i = 0; i < 7; i++)
                      Expanded(
                        child: i < week.length
                            ? _DayCell(day: week[i])
                            : const SizedBox(height: 32),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                const _LegendDot(color: AppColors.divider, label: 'Inactif'),
                const SizedBox(width: 12),
                _LegendDot(
                  color: AppColors.success.withValues(alpha: 0.5),
                  label: 'Actif',
                ),
                const SizedBox(width: 12),
                const _LegendDot(color: AppColors.success, label: 'Intense'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day});
  final CalendarDay day;

  Color _color() {
    if (!day.active) return AppColors.surfaceAlt;
    if (day.xpEarned >= 60) return AppColors.success;
    if (day.xpEarned >= 25) return AppColors.success.withValues(alpha: 0.7);
    return AppColors.success.withValues(alpha: 0.4);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: AspectRatio(
        aspectRatio: 1,
        child: Tooltip(
          message:
              '${day.date.day}/${day.date.month} — ${day.minutesLearned} min, ${day.xpEarned} XP',
          child: Container(
            decoration: BoxDecoration(
              color: _color(),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.date.day}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: day.active ? Colors.white : AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: AppColors.border),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
