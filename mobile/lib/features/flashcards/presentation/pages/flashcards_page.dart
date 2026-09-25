import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:langapp/features/flashcards/domain/entities/flashcard_session.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/flashcards_controller.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/quality_buttons.dart';
import 'flashcard_summary_page.dart';

class FlashcardsPage extends ConsumerStatefulWidget {
  const FlashcardsPage({super.key});

  @override
  ConsumerState<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends ConsumerState<FlashcardsPage> {
  final _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(flashcardsControllerProvider.notifier).startDue();
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(flashcardsControllerProvider);
    final controller = ref.read(flashcardsControllerProvider.notifier);
    final theme = Theme.of(context);

    // Fin de session → redirige vers résumé
    if (session.status == FlashcardSessionStatus.finished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => FlashcardSummaryPage(session: session),
            ),
          );
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (session.status == FlashcardSessionStatus.idle) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final card = session.current;
    if (card == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('${session.completed + 1} / ${session.total}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: session.progress,
                minHeight: 6,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: FlashcardWidget(
                    card: card,
                    showBack: session.showBack,
                    onFlip: () {
                      if (!session.showBack) {
                        controller.revealBack();
                      } else {
                        // Re-flip : retour au recto (utile si l'utilisateur
                        // veut se re-tester sans répondre).
                        // Ici on ne fait rien car le bouton apparaît déjà.
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (session.showBack)
                QualityButtons(
                  onSelect: (q) => controller.answer(
                    q,
                    responseTimeMs: _stopwatch.elapsedMilliseconds,
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: controller.revealBack,
                    child: const Text('Révéler la réponse'),
                  ),
                ),
              const SizedBox(height: 8),
              if (!session.showBack)
                Text(
                  'Touchez la carte pour la retourner',
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
