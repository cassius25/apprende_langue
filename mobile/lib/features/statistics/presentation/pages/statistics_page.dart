import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/statistics_providers.dart';
import '../widgets/activity_chart.dart';
import '../widgets/skills_bar.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key});

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage> {
  int _days = 30;

  @override
  Widget build(BuildContext context) {
    final overviewAsync = ref.watch(overviewStatsProvider);
    final activityAsync = ref.watch(
      activityChartProvider(ActivityQuery(days: _days)),
    );
    final skillsAsync = ref.watch(skillsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(overviewStatsProvider);
            ref.invalidate(activityChartProvider(ActivityQuery(days: _days)));
            ref.invalidate(skillsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ─── Overview ─────────────────────────────────
              overviewAsync.when(
                data: (o) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _KpiGrid(
                      items: [
                        _Kpi(
                          'XP total',
                          '${o.xpTotal}',
                          Icons.bolt_rounded,
                          AppColors.secondary,
                        ),
                        _Kpi(
                          'Niveau',
                          '${o.userLevel}',
                          Icons.military_tech_outlined,
                          AppColors.primary,
                        ),
                        _Kpi(
                          'Série',
                          '${o.streakCurrent}',
                          Icons.local_fire_department_outlined,
                          AppColors.streakFire,
                        ),
                        _Kpi(
                          'Temps total',
                          '${o.totalMinutes} min',
                          Icons.schedule_outlined,
                          AppColors.info,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _KpiGrid(
                      items: [
                        _Kpi(
                          'Mots appris',
                          '${o.wordsLearned}',
                          Icons.style_outlined,
                          AppColors.accent,
                        ),
                        _Kpi(
                          'Maîtrisés',
                          '${o.wordsMastered}',
                          Icons.verified_outlined,
                          AppColors.success,
                        ),
                        _Kpi(
                          'Exercices',
                          '${o.exercisesDone}',
                          Icons.quiz_outlined,
                          AppColors.primary,
                        ),
                        _Kpi(
                          'Taux réussite',
                          '${o.exercisesSuccessRate.toStringAsFixed(0)}%',
                          Icons.trending_up_rounded,
                          AppColors.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cette semaine',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${o.last7DaysMinutes} min sur les 7 derniers jours '
                              '(${o.last30DaysMinutes} min sur 30 jours)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value:
                                    o.xpInLevel /
                                    (o.xpInLevel + o.xpToNextLevel),
                                minHeight: 10,
                                backgroundColor: AppColors.divider,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Niveau ${o.userLevel} — ${o.xpInLevel} / ${o.xpInLevel + o.xpToNextLevel} XP',
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                loading: () => const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Impossible de charger les statistiques. $e'),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ─── Période selector ─────────────────────────
              Row(
                children: [
                  for (final n in const [7, 30, 90])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('$n j'),
                        selected: _days == n,
                        onSelected: (_) => setState(() => _days = n),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // ─── Activité ─────────────────────────────────
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: activityAsync.when(
                    data: (chart) => ActivityBarChart(days: chart.days),
                    loading: () => const SizedBox(
                      height: 160,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Text('$e'),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ─── Compétences ──────────────────────────────
              skillsAsync.when(
                data: (skills) => SkillsBar(skills: skills),
                loading: () => const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text('$e'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Kpi {
  const _Kpi(this.label, this.value, this.icon, this.color);
  final String label;
  final String value;
  final IconData icon;
  final Color color;
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.items});
  final List<_Kpi> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(child: _KpiCard(kpi: items[i])),
          if (i < items.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.kpi});
  final _Kpi kpi;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Icon(kpi.icon, color: kpi.color),
            const SizedBox(height: 6),
            Text(
              kpi.value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: kpi.color,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              kpi.label,
              style: theme.textTheme.labelSmall,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
