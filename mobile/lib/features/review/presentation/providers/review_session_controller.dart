import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:langapp/core/utils/result.dart';

import '../../../../core/utils/logger.dart';
import '../../../flashcards/domain/entities/flashcard.dart';
import '../../../flashcards/domain/entities/flashcard_session.dart';
import '../../domain/entities/review_session_config.dart';
import '../../domain/entities/review_stats.dart';
import '../../domain/repositories/review_repository.dart';
import 'review_providers.dart';

// ─────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────

enum ReviewStatus { idle, loading, running, submitting, finished, empty, error }

class ReviewSessionState extends Equatable {
  const ReviewSessionState({
    this.status = ReviewStatus.idle,
    this.config = const ReviewSessionConfig(),
    this.cards = const [],
    this.currentIndex = 0,
    this.answers = const [],
    this.showBack = false,
    this.stats,
    this.errorMessage,
  });

  final ReviewStatus status;
  final ReviewSessionConfig config;
  final List<Flashcard> cards;
  final int currentIndex;
  final List<ReviewAnswer> answers;
  final bool showBack;
  final ReviewSessionStats? stats;
  final String? errorMessage;

  Flashcard? get current =>
      (status == ReviewStatus.running && currentIndex < cards.length)
      ? cards[currentIndex]
      : null;

  int get total => cards.length;
  int get answered => answers.length;
  double get progress => total == 0 ? 0 : answered / total;
  int get correctCount => answers.where((a) => a.quality >= 3).length;

  ReviewSessionState copyWith({
    ReviewStatus? status,
    ReviewSessionConfig? config,
    List<Flashcard>? cards,
    int? currentIndex,
    List<ReviewAnswer>? answers,
    bool? showBack,
    ReviewSessionStats? stats,
    String? errorMessage,
  }) {
    return ReviewSessionState(
      status: status ?? this.status,
      config: config ?? this.config,
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      showBack: showBack ?? this.showBack,
      stats: stats ?? this.stats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, currentIndex, answers.length, showBack];
}

// ─────────────────────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────────────────────

class ReviewSessionController extends Notifier<ReviewSessionState> {
  @override
  ReviewSessionState build() => const ReviewSessionState();

  /// Met à jour la configuration avant de démarrer.
  void updateConfig(ReviewSessionConfig config) {
    state = state.copyWith(config: config);
  }

  /// Démarre une nouvelle session.
  Future<void> start() async {
    state = state.copyWith(status: ReviewStatus.loading);
    final cfg = state.config;

    final result = await ref
        .read(loadReviewQueueUseCaseProvider)
        .call(
          languageId: cfg.languageId,
          limit: cfg.batchSize,
          includeNew: cfg.includeNew,
          shuffle: cfg.shuffle,
        );

    result.fold(
      (f) => state = state.copyWith(
        status: ReviewStatus.error,
        errorMessage: f.message,
      ),
      (cards) {
        if (cards.isEmpty) {
          state = state.copyWith(status: ReviewStatus.empty, cards: const []);
        } else {
          state = ReviewSessionState(
            status: ReviewStatus.running,
            config: cfg,
            cards: cards,
            currentIndex: 0,
            answers: const [],
          );
          _persist();
        }
      },
    );
  }

  void revealBack() {
    if (state.current == null || state.showBack) return;
    state = state.copyWith(showBack: true);
  }

  /// Enregistre la réponse **sans soumettre** (batch à la fin).
  void answer(int quality, {int? responseTimeMs}) {
    final card = state.current;
    if (card == null) return;

    final newAnswers = [
      ...state.answers,
      ReviewAnswer(
        flashcard: card,
        quality: quality,
        responseTimeMs: responseTimeMs,
      ),
    ];

    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.cards.length) {
      // Toutes les cartes ont été répondues → soumission batch.
      state = state.copyWith(
        answers: newAnswers,
        currentIndex: nextIndex,
        showBack: false,
      );
      _persist();
      _submitBatch();
    } else {
      state = state.copyWith(
        answers: newAnswers,
        currentIndex: nextIndex,
        showBack: false,
      );
      _persist();
    }
  }

  Future<void> _submitBatch() async {
    state = state.copyWith(status: ReviewStatus.submitting);
    final result = await ref
        .read(submitReviewBatchUseCaseProvider)
        .call(state.answers);

    result.fold(
      (f) {
        AppLogger.w('Review: submitBatch failed — ${f.message}');
        state = state.copyWith(
          status: ReviewStatus.finished,
          stats: const ReviewSessionStats.empty(),
          errorMessage: f.message,
        );
      },
      (stats) {
        state = state.copyWith(status: ReviewStatus.finished, stats: stats);
        ref.read(reviewSessionCacheProvider).clear();
      },
    );
  }

  /// Réessai après erreur de chargement.
  void retry() {
    if (state.status != ReviewStatus.error) return;
    state = state.copyWith(status: ReviewStatus.idle);
    start();
  }

  void reset() => state = ReviewSessionState(config: state.config);

  // ─── Persistance ──────────────────────────────────────────
  Future<void> _persist() async {
    if (state.status != ReviewStatus.running) return;
    try {
      await ref
          .read(reviewSessionCacheProvider)
          .save(
            cards: state.cards,
            answers: state.answers,
            currentIndex: state.currentIndex,
          );
    } catch (e) {
      AppLogger.w('Review: persist failed — $e');
    }
  }

  /// Tente de restaurer une session sauvegardée (appelé au démarrage).
  /// Renvoie `true` si une session a été restaurée.
  Future<bool> tryRestore() async {
    final cache = ref.read(reviewSessionCacheProvider);
    final data = await cache.load();
    if (data == null) return false;

    try {
      // Session trop vieille (> 24h) : on abandonne.
      final savedAt = DateTime.tryParse(data['savedAt'] as String? ?? '');
      if (savedAt == null ||
          DateTime.now().difference(savedAt) > const Duration(hours: 24)) {
        await cache.clear();
        return false;
      }

      final rawCards = (data['cards'] as List?) ?? const [];
      final rawAnswers = (data['answers'] as List?) ?? const [];
      final currentIndex = (data['currentIndex'] as num?)?.toInt() ?? 0;

      // Recharge les cartes complètes depuis le repository.
      final queueResult = await ref
          .read(loadReviewQueueUseCaseProvider)
          .call(limit: rawCards.length);
      if (queueResult.isLeft()) return false;
      final freshCards = queueResult.valueOrNull!;

      // Mappe par userVocabularyId.
      final byId = {for (final c in freshCards) c.entry.userVocabularyId: c};

      final restoredCards = <Flashcard>[];
      for (final raw in rawCards) {
        final id = (raw as Map)['userVocabularyId'] as String?;
        if (id == null) continue;
        final card = byId[id];
        if (card != null) restoredCards.add(card);
      }

      if (restoredCards.isEmpty) {
        await cache.clear();
        return false;
      }

      // Reconstruit les ReviewAnswer.
      final restoredAnswers = <ReviewAnswer>[];
      for (final raw in rawAnswers) {
        final m = raw as Map;
        final id = m['userVocabularyId'] as String?;
        if (id == null) continue;
        final card = byId[id];
        if (card == null) continue;
        restoredAnswers.add(
          ReviewAnswer(
            flashcard: card,
            quality: (m['quality'] as num?)?.toInt() ?? 3,
            responseTimeMs: (m['responseTimeMs'] as num?)?.toInt(),
          ),
        );
      }

      state = ReviewSessionState(
        status: ReviewStatus.running,
        config: state.config,
        cards: restoredCards,
        currentIndex: currentIndex.clamp(0, restoredCards.length),
        answers: restoredAnswers,
      );
      return true;
    } catch (e) {
      AppLogger.w('Review: restore failed — $e');
      await cache.clear();
      return false;
    }
  }
}

final reviewSessionControllerProvider =
    NotifierProvider<ReviewSessionController, ReviewSessionState>(
      ReviewSessionController.new,
    );

// ─────────────────────────────────────────────────────────────
// FlashcardSessionStatus import (évite warning d'unused import)
// ─────────────────────────────────────────────────────────────

// ignore: unused_element
const _kFlashcardStatus = FlashcardSessionStatus.idle;
