import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/flashcard_session.dart';
import '../providers/flashcards_controller.dart';

class FlashcardSummaryPage extends ConsumerWidget {
  const FlashcardSummaryPage({super.key, required this.session});
  final FlashcardSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final total = session.total;
    final correct = session.correctCount;
    final percent = total == 0 ? 0 : (correct / total * 100).round();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        ref.read(flashcardsControllerProvider.notifier).reset();
        if (context.mounted) context.goNamed(RouteNames.home);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 120,
                  height: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$percent%',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Session terminée !',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '$correct / $total bonnes réponses',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                _StatRow(label: 'Cartes revues', value: '$total'),
                _StatRow(label: 'Bonnes réponses', value: '$correct'),
                _StatRow(label: 'À revoir', value: '${total - correct}'),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    ref.read(flashcardsControllerProvider.notifier).reset();
                    context.goNamed(RouteNames.home);
                  },
                  child: const Text('Terminer'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    ref.read(flashcardsControllerProvider.notifier).reset();
                    context.go('/learn/flashcards');
                  },
                  child: const Text('Nouvelle session'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
