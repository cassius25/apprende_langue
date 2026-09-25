import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/statistics.dart';

/// Bar chart simple dessiné via `CustomPaint` (aucune dépendance supplémentaire).
class ActivityBarChart extends StatelessWidget {
  const ActivityBarChart({super.key, required this.days});
  final List<ActivityDay> days;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return SizedBox(
        height: 140,
        child: Center(
          child: Text(
            'Aucune activité sur la période.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
    }

    final maxY = days.fold<int>(1, (a, d) => d.xpEarned > a ? d.xpEarned : a);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('XP par jour', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: CustomPaint(
            painter: _BarsPainter(days: days, maxY: maxY),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _fmt(days.first.date),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              _fmt(days.last.date),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
    );
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}';
}

class _BarsPainter extends CustomPainter {
  _BarsPainter({required this.days, required this.maxY});
  final List<ActivityDay> days;
  final int maxY;

  @override
  void paint(Canvas canvas, Size size) {
    final paintBar = Paint()..color = AppColors.primary;
    final paintBg = Paint()..color = AppColors.divider;
    final barWidth = size.width / days.length;

    for (var i = 0; i < days.length; i++) {
      final d = days[i];
      final ratio = (d.xpEarned / maxY).clamp(0.0, 1.0);
      final h = (size.height - 6) * ratio;

      // fond
      final bgRect = Rect.fromLTWH(
        i * barWidth + 1,
        3,
        barWidth - 2,
        size.height - 6,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(bgRect, const Radius.circular(3)),
        paintBg,
      );

      // barre
      if (h > 0) {
        final rect = Rect.fromLTWH(
          i * barWidth + 1,
          size.height - 3 - h,
          barWidth - 2,
          h,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(3)),
          paintBar,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarsPainter old) =>
      old.days != days || old.maxY != maxY;
}
