import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:langapp/features/goals/domain/repositories/goal_repository.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../domain/entities/daily_goal.dart';
import '../providers/goals_providers.dart';

class GoalsPage extends ConsumerStatefulWidget {
  const GoalsPage({super.key});

  @override
  ConsumerState<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends ConsumerState<GoalsPage> {
  bool _saving = false;

  Future<void> _save({required GoalType type, required int target}) async {
    setState(() => _saving = true);
    final result = await ref
        .read(upsertGoalUseCaseProvider)
        .call(type: type, target: target);
    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.message))),
      (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Objectif enregistré.')));
        ref.invalidate(todayGoalProvider);
        ref.invalidate(allGoalsProvider);
        ref.invalidate(dashboardSnapshotProvider);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(todayGoalProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Objectif quotidien')),
      body: SafeArea(
        child: async.when(
          data: (today) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (today != null && today.goal != null) ...[
                _CurrentGoalCard(today: today),
                const SizedBox(height: 24),
              ],
              Text('Définir un objectif', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              _TypeSelector(
                initial: today?.goal?.type ?? GoalType.minutes,
                initialTarget: today?.target ?? 10,
                saving: _saving,
                onSave: (type, target) => _save(type: type, target: target),
              ),
              const SizedBox(height: 24),
              Text(
                'Pourquoi un objectif ?',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Des objectifs quotidiens courts mais réguliers sont plus efficaces que de longues sessions ponctuelles. '
                'Choisissez ce que vous pouvez tenir tous les jours.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
        ),
      ),
    );
  }
}

class _CurrentGoalCard extends StatelessWidget {
  const _CurrentGoalCard({required this.today});
  final TodayGoal today;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unit = today.goal?.type == GoalType.minutes ? 'min' : 'mots';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Objectif du jour', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${today.current} / ${today.target} $unit',
                  style: theme.textTheme.headlineSmall,
                ),
                const Spacer(),
                if (today.achieved)
                  const Text('🎉', style: TextStyle(fontSize: 28)),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (today.progressPercent) / 100,
                minHeight: 10,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(
                  today.achieved ? AppColors.success : AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${(today.progressPercent).toStringAsFixed(0)} %',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeSelector extends StatefulWidget {
  const _TypeSelector({
    required this.initial,
    required this.initialTarget,
    required this.saving,
    required this.onSave,
  });

  final GoalType initial;
  final int initialTarget;
  final bool saving;
  final void Function(GoalType type, int target) onSave;

  @override
  State<_TypeSelector> createState() => _TypeSelectorState();
}

class _TypeSelectorState extends State<_TypeSelector> {
  late GoalType _type;
  late int _target;

  @override
  void initState() {
    super.initState();
    _type = widget.initial;
    _target = widget.initialTarget;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minutes = [5, 10, 15, 20, 30];
    final words = [5, 10, 20, 30, 50];
    final options = _type == GoalType.minutes ? minutes : words;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<GoalType>(
          segments: const [
            ButtonSegment(
              value: GoalType.minutes,
              label: Text('Minutes'),
              icon: Icon(Icons.timer_outlined),
            ),
            ButtonSegment(
              value: GoalType.words,
              label: Text('Mots'),
              icon: Icon(Icons.abc_rounded),
            ),
          ],
          selected: {_type},
          onSelectionChanged: (s) {
            setState(() {
              _type = s.first;
              _target = _type == GoalType.minutes ? 10 : 10;
            });
          },
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final v in options)
              ChoiceChip(
                label: Text('$v'),
                selected: _target == v,
                onSelected: (_) => setState(() => _target = v),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Objectif : $_target ${_type == GoalType.minutes ? "minutes" : "mots"} par jour',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: widget.saving ? null : () => widget.onSave(_type, _target),
          child: widget.saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Enregistrer l’objectif'),
        ),
      ],
    );
  }
}
