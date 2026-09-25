import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/streak_providers.dart';
import '../widgets/streak_calendar.dart';

class StreakPage extends ConsumerStatefulWidget {
  const StreakPage({super.key});

  @override
  ConsumerState<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends ConsumerState<StreakPage> {
  int _offset = 0;

  @override
  Widget build(BuildContext context) {
    final infoAsync = ref.watch(streakInfoProvider);
    final calendarQuery = CalendarQuery(days: 28, offset: _offset);
    final calendarAsync = ref.watch(streakCalendarProvider(calendarQuery));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Série de jours')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(streakInfoProvider);
            ref.invalidate(streakCalendarProvider(calendarQuery));
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              infoAsync.when(
                data: (info) => _StreakHero(info: info),
                loading: () => const SizedBox(
                  height: 140,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text('$e'),
              ),
              const SizedBox(height: 16),
              calendarAsync.when(
                data: (cal) => StreakCalendarWidget(
                  calendar: cal,
                  onPrevious: () => setState(() => _offset += 28),
                  onNext: _offset == 0
                      ? null
                      : () => setState(
                          () => _offset = (_offset - 28).clamp(0, 100000),
                        ),
                ),
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text('$e'),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comment ça marche ?',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Votre série augmente chaque jour où vous apprenez. '
                        'Elle repart de zéro si vous manquez un jour. '
                        'Apprenez un peu chaque jour pour ne pas perdre le rythme !',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakHero extends StatelessWidget {
  const _StreakHero({required this.info});
  final dynamic info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 96,
              height: 96,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.streakFire.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Text('🔥', style: TextStyle(fontSize: 48)),
            ),
            const SizedBox(height: 16),
            Text(
              '${info.currentStreak}',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.streakFire,
              ),
            ),
            Text(
              info.currentStreak == 1 ? 'jour de série' : 'jours de série',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    label: 'Meilleure série',
                    value: '${info.longestStreak}',
                    icon: Icons.emoji_events_outlined,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MiniStat(
                    label: 'Jours actifs',
                    value: '${info.totalActiveDays}',
                    icon: Icons.calendar_month_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.textSecondary),
          const SizedBox(height: 6),
          Text(value, style: theme.textTheme.titleLarge),
          Text(
            label,
            style: theme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
