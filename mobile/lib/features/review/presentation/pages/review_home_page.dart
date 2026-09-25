import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../domain/entities/review_session_config.dart';
import '../providers/review_providers.dart';
import '../providers/review_session_controller.dart';
import '../widgets/review_filter_sheet.dart';

class ReviewHomePage extends ConsumerStatefulWidget {
  const ReviewHomePage({super.key});

  @override
  ConsumerState<ReviewHomePage> createState() => _ReviewHomePageState();
}

class _ReviewHomePageState extends ConsumerState<ReviewHomePage> {
  @override
  void initState() {
    super.initState();
    // Tente de restaurer une session interrompue.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final restored = await ref
          .read(reviewSessionControllerProvider.notifier)
          .tryRestore();
      if (restored && mounted) {
        _showResumeBanner();
      }
    });
  }

  void _showResumeBanner() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Une session de révision a été restaurée.'),
        action: SnackBarAction(
          label: 'Reprendre',
          onPressed: () => context.push('/review/session'),
        ),
      ),
    );
  }

  Future<void> _configureAndStart() async {
    final current = ref.read(reviewSessionControllerProvider).config;
    final result = await showReviewFilterSheet(context, initial: current);
    if (result == null) return;
    if (!mounted) return;
    ref.read(reviewSessionControllerProvider.notifier).updateConfig(result);
    await context.push('/review/session');
  }

  Future<void> _startQuick() async {
    if (!mounted) return;
    await context.push('/review/session');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summaryAsync = ref.watch(reviewQueueSummaryProvider);
    final dueAsync = ref.watch(dueReviewCountProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Réviser')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(reviewQueueSummaryProvider);
            ref.invalidate(dueReviewCountProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ─── Header ─────────────────────────────────
              Text('Répétition espacée', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                'Consolidez votre vocabulaire en révisant aux bons moments.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // ─── Due count card ─────────────────────────
              dueAsync.when(
                data: (count) => _DueCountCard(
                  count: count,
                  onStart: count == 0 ? null : _startQuick,
                ),
                loading: () => const _SkeletonCard(height: 140),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 12),

              // ─── Queue summary ──────────────────────────
              summaryAsync.when(
                data: (summary) => _QueueSummaryCard(summary: summary),
                loading: () => const _SkeletonCard(height: 120),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),

              // ─── Actions ────────────────────────────────
              FilledButton.icon(
                onPressed: _startQuick,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Démarrer une session'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _configureAndStart,
                icon: const Icon(Icons.tune_rounded),
                label: const Text('Configurer et démarrer'),
              ),
              const SizedBox(height: 16),

              // ─── Aide ───────────────────────────────────
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.info,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Les mots reviennent à intervalles croissants. '
                          'Répondez honnêtement pour un calendrier optimal.',
                          style: theme.textTheme.bodySmall,
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

class _DueCountCard extends StatelessWidget {
  const _DueCountCard({required this.count, this.onStart});
  final int count;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isZero = count == 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (isZero ? AppColors.success : AppColors.primary)
                    .withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isZero ? AppColors.success : AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isZero ? 'Tout est à jour !' : 'mots à réviser',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isZero
                        ? 'Revenez plus tard pour consolider votre mémoire.'
                        : 'Prêt pour une session ?',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (!isZero && onStart != null)
              IconButton(
                onPressed: onStart,
                icon: const Icon(Icons.play_circle_fill_rounded),
                iconSize: 40,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}

class _QueueSummaryCard extends StatelessWidget {
  const _QueueSummaryCard({required this.summary});
  final dynamic summary; // ReviewQueueSummary

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Votre vocabulaire', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                _SummaryPill(
                  label: 'Dus',
                  value: '${summary.dueCount}',
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                _SummaryPill(
                  label: 'Apprentissage',
                  value: '${summary.learningCount}',
                  color: AppColors.warning,
                ),
                const SizedBox(width: 8),
                _SummaryPill(
                  label: 'Révision',
                  value: '${summary.reviewCount}',
                  color: AppColors.info,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _SummaryPill(
                  label: 'Maîtrisés',
                  value: '${summary.masteredCount}',
                  color: AppColors.success,
                ),
                const SizedBox(width: 8),
                _SummaryPill(
                  label: 'Nouveaux',
                  value: '${summary.newCount}',
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(color: color),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

// évite l'import inutilisé
// ignore: unused_element
void _keep(WidgetRef ref) => ref.read(dashboardSnapshotProvider);
// ignore: unused_element
const _kNoop = ReviewSessionConfig();
