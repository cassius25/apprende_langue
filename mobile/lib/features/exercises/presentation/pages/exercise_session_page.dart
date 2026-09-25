import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/exercise.dart';
import '../providers/exercise_session_controller.dart';
import '../widgets/exercise_feedback_sheet.dart';
import '../widgets/fill_in_blank_widget.dart';
import '../widgets/listening_widget.dart';
import '../widgets/matching_widget.dart';
import '../widgets/pronunciation_widget.dart';
import '../widgets/qcm_widget.dart';
import '../widgets/translation_widget.dart';
import '../widgets/word_order_widget.dart';
import 'exercise_summary_page.dart';

class ExerciseSessionPage extends ConsumerStatefulWidget {
  const ExerciseSessionPage({super.key, required this.lessonId});
  final String lessonId;

  @override
  ConsumerState<ExerciseSessionPage> createState() =>
      _ExerciseSessionPageState();
}

class _ExerciseSessionPageState extends ConsumerState<ExerciseSessionPage> {
  Map<String, dynamic>? _payload;
  final _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(exerciseSessionControllerProvider.notifier)
          .start(widget.lessonId);
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  void _onPayloadChanged(Map<String, dynamic>? payload) {
    if (!mounted) return;
    setState(() => _payload = payload);
  }

  Future<void> _verify() async {
    final payload = _payload;
    if (payload == null) return;
    FocusScope.of(context).unfocus();

    final ctrl = ref.read(exerciseSessionControllerProvider.notifier);
    final responseMs = _stopwatch.elapsedMilliseconds;
    _stopwatch.reset();
    _stopwatch.start();

    await ctrl.submitCurrent(payload, responseTimeMs: responseMs);
  }

  void _next() {
    ref.read(exerciseSessionControllerProvider.notifier).next();
    setState(() => _payload = null);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exerciseSessionControllerProvider);
    final theme = Theme.of(context);

    // Redirection vers le résumé
    if (state.status == ExerciseSessionStatus.finished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => ExerciseSummaryPage(state: state),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        title:
            state.status == ExerciseSessionStatus.running ||
                state.status == ExerciseSessionStatus.showingFeedback
            ? Text('${state.currentIndex + 1} / ${state.total}')
            : const Text('Exercices'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: state.total == 0 ? 0 : state.completed / state.total,
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
        top: false,
        child: switch (state.status) {
          ExerciseSessionStatus.loading => const Center(
            child: CircularProgressIndicator(),
          ),
          ExerciseSessionStatus.empty => _EmptyView(
            onBack: () => context.pop(),
          ),
          ExerciseSessionStatus.error => _ErrorView(
            message: state.errorMessage ?? 'Erreur inattendue',
            onRetry: () {
              ref
                  .read(exerciseSessionControllerProvider.notifier)
                  .retryFromError();
            },
            onBack: () => context.pop(),
          ),
          ExerciseSessionStatus.running ||
          ExerciseSessionStatus.showingFeedback => _SessionBody(
            state: state,
            payload: _payload,
            onPayloadChanged: _onPayloadChanged,
            onVerify: _verify,
            onNext: _next,
          ),
          ExerciseSessionStatus.finished => const SizedBox.shrink(),
        },
      ),
      bottomSheet:
          state.status == ExerciseSessionStatus.showingFeedback &&
              state.lastCorrection != null
          ? ExerciseFeedbackSheet(
              correction: state.lastCorrection!,
              isLast: state.currentIndex + 1 >= state.total,
              onNext: _next,
            )
          : null,
    ).withBackground(theme);
  }
}

extension on Scaffold {
  Widget withBackground(ThemeData theme) =>
      this; // no-op conservé pour lisibilité
}

class _SessionBody extends StatelessWidget {
  const _SessionBody({
    required this.state,
    required this.payload,
    required this.onPayloadChanged,
    required this.onVerify,
    required this.onNext,
  });

  final ExerciseSessionState state;
  final Map<String, dynamic>? payload;
  final ValueChanged<Map<String, dynamic>?> onPayloadChanged;
  final VoidCallback onVerify;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final ex = state.current;
    if (ex == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final showFeedback = state.status == ExerciseSessionStatus.showingFeedback;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _TypeBadge(type: ex.type),
        const SizedBox(height: 12),
        Text(ex.question, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 20),
        _buildInput(ex, showFeedback, onPayloadChanged),
        const SizedBox(height: 24),
        if (!showFeedback)
          FilledButton(
            onPressed: payload != null ? onVerify : null,
            child: const Text('Vérifier'),
          ),
      ],
    );
  }

  Widget _buildInput(
    Exercise ex,
    bool showFeedback,
    ValueChanged<Map<String, dynamic>?> onChanged,
  ) {
    switch (ex.type) {
      case ExerciseType.multipleChoice:
        return QcmWidget(
          exercise: ex,
          onChanged: onChanged,
          disabled: showFeedback,
        );
      case ExerciseType.translation:
        return TranslationWidget(
          exercise: ex,
          onChanged: onChanged,
          disabled: showFeedback,
        );
      case ExerciseType.fillInTheBlank:
        return FillInBlankWidget(
          exercise: ex,
          onChanged: onChanged,
          disabled: showFeedback,
        );
      case ExerciseType.matching:
        return MatchingWidget(
          exercise: ex,
          onChanged: onChanged,
          disabled: showFeedback,
        );
      case ExerciseType.wordOrder:
        return WordOrderWidget(
          exercise: ex,
          onChanged: onChanged,
          disabled: showFeedback,
        );
      case ExerciseType.listening:
        return ListeningWidget(
          exercise: ex,
          onChanged: onChanged,
          disabled: showFeedback,
        );
      case ExerciseType.pronunciation:
        return PronunciationWidget(
          exercise: ex,
          onChanged: onChanged,
          disabled: showFeedback,
        );
    }
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});
  final ExerciseType type;

  String _label() {
    switch (type) {
      case ExerciseType.multipleChoice:
        return 'Choix multiple';
      case ExerciseType.translation:
        return 'Traduction';
      case ExerciseType.fillInTheBlank:
        return 'Compléter';
      case ExerciseType.matching:
        return 'Association';
      case ExerciseType.wordOrder:
        return 'Ordre des mots';
      case ExerciseType.listening:
        return 'Écoute';
      case ExerciseType.pronunciation:
        return 'Prononciation';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _label(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun exercice pour cette leçon',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Revenez plus tard ou explorez d’autres leçons.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: onBack, child: const Text('Retour')),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.onBack,
  });
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton(onPressed: onRetry, child: const Text('Réessayer')),
            const SizedBox(height: 8),
            TextButton(onPressed: onBack, child: const Text('Retour')),
          ],
        ),
      ),
    );
  }
}
