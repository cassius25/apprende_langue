import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../flashcards/presentation/widgets/flashcard_widget.dart';
import '../../../flashcards/presentation/widgets/quality_buttons.dart';
import '../providers/review_session_controller.dart';
import '../widgets/review_progress_header.dart';
import 'review_summary_page.dart';

class ReviewSessionPage extends ConsumerStatefulWidget {
  const ReviewSessionPage({super.key});

  @override
  ConsumerState<ReviewSessionPage> createState() => _ReviewSessionPageState();
}

class _ReviewSessionPageState extends ConsumerState<ReviewSessionPage> {
  final _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _stopwatch.start();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ctrl = ref.read(reviewSessionControllerProvider.notifier);
      final state = ref.read(reviewSessionControllerProvider);
      // Si la session n'est pas déjà en cours (restaurée), on en démarre une.
      if (state.status != ReviewStatus.running) {
        await ctrl.start();
      }
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  void _reveal() {
    ref.read(reviewSessionControllerProvider.notifier).revealBack();
  }

  void _answer(int quality) {
    final ms = _stopwatch.elapsedMilliseconds;
    _stopwatch.reset();
    _stopwatch.start();
    ref
        .read(reviewSessionControllerProvider.notifier)
        .answer(quality, responseTimeMs: ms);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewSessionControllerProvider);
    final theme = Theme.of(context);

    // Redirection vers le résumé.
    if (state.status == ReviewStatus.finished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const ReviewSummaryPage()),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => _confirmExit(),
        ),
        title: const Text('Session de révision'),
      ),
      body: SafeArea(child: _buildBody(state, theme)),
    );
  }

  Widget _buildBody(ReviewSessionState state, ThemeData theme) {
    switch (state.status) {
      case ReviewStatus.idle:
      case ReviewStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case ReviewStatus.empty:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 16),
                Text(
                  'Aucune carte à réviser',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Revenez plus tard — votre mémoire consolide en arrière-plan.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.pop(),
                  child: const Text('Retour'),
                ),
              ],
            ),
          ),
        );

      case ReviewStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.cloud_off_rounded,
                  size: 48,
                  color: AppColors.textMuted,
                ),
                const SizedBox(height: 12),
                Text(
                  state.errorMessage ?? 'Erreur inattendue',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => ref
                      .read(reviewSessionControllerProvider.notifier)
                      .retry(),
                  child: const Text('Réessayer'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Retour'),
                ),
              ],
            ),
          ),
        );

      case ReviewStatus.submitting:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Enregistrement de la session…'),
            ],
          ),
        );

      case ReviewStatus.running:
        final card = state.current;
        if (card == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ReviewProgressHeader(
                current: state.currentIndex,
                total: state.total,
                correct: state.correctCount,
                wrong: state.answered - state.correctCount,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: FlashcardWidget(
                    card: card,
                    showBack: state.showBack,
                    onFlip: _reveal,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (state.showBack)
                QualityButtons(onSelect: _answer)
              else
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _reveal,
                    child: const Text('Révéler la réponse'),
                  ),
                ),
              const SizedBox(height: 8),
              if (!state.showBack)
                Text(
                  'Touchez la carte pour la retourner',
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
        );

      case ReviewStatus.finished:
        return const Center(child: CircularProgressIndicator());
    }
  }

  Future<void> _confirmExit() async {
    final state = ref.read(reviewSessionControllerProvider);
    if (state.status != ReviewStatus.running || state.answered == 0) {
      ref.read(reviewSessionControllerProvider.notifier).reset();
      if (context.mounted) context.pop();
      return;
    }

    final leave = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quitter la session ?'),
        content: const Text(
          'Vos réponses en cours sont enregistrées. Vous pourrez reprendre plus tard.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continuer'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) {
      context.pop();
    }
  }
}
