import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/entities/flashcard_session.dart';
import 'flashcards_providers.dart';

/// Contrôleur de session flashcards.
class FlashcardsController extends Notifier<FlashcardSession> {
  @override
  FlashcardSession build() {
    return const FlashcardSession(
      cards: [],
      currentIndex: 0,
      results: [],
      status: FlashcardSessionStatus.idle,
    );
  }

  /// Charge les cartes dues et démarre une session.
  Future<void> startDue({int limit = 50}) async {
    state = state.copyWith(status: FlashcardSessionStatus.idle);
    final result = await ref
        .read(loadFlashcardsUseCaseProvider)
        .call(limit: limit);
    result.fold(
      (f) {
        AppLogger.w('Flashcards: loadDue failed — ${f.message}');
        state = const FlashcardSession(
          cards: [],
          currentIndex: 0,
          results: [],
          status: FlashcardSessionStatus.finished,
        );
      },
      (cards) {
        if (cards.isEmpty) {
          state = const FlashcardSession(
            cards: [],
            currentIndex: 0,
            results: [],
            status: FlashcardSessionStatus.finished,
          );
        } else {
          state = FlashcardSession(
            cards: cards,
            currentIndex: 0,
            results: const [],
            status: FlashcardSessionStatus.running,
          );
        }
      },
    );
  }

  /// Démarre une session avec des cartes fournies (preview detail page).
  Future<void> startCustom(List<Flashcard> cards) async {
    if (cards.isEmpty) {
      state = const FlashcardSession(
        cards: [],
        currentIndex: 0,
        results: [],
        status: FlashcardSessionStatus.finished,
      );
      return;
    }
    state = FlashcardSession(
      cards: cards,
      currentIndex: 0,
      results: const [],
      status: FlashcardSessionStatus.running,
    );
  }

  /// Retourne la carte (reveal back).
  void revealBack() {
    if (state.current == null) return;
    state = state.copyWith(showBack: true);
  }

  /// Enregistre une réponse (quality 0..5) et passe à la carte suivante.
  Future<void> answer(int quality, {int? responseTimeMs}) async {
    final card = state.current;
    if (card == null) return;

    final result = await ref
        .read(submitFlashcardAnswerUseCaseProvider)
        .call(card: card, quality: quality, responseTimeMs: responseTimeMs);

    // On continue même en cas d'échec (mode offline-first : la carte est
    // déjà mise à jour localement par le repository en fallback).
    final isCorrect = quality >= 3;
    final newResults = [
      ...state.results,
      FlashcardResult(flashcard: card, quality: quality, isCorrect: isCorrect),
    ];

    result.fold(
      (f) => AppLogger.w('Flashcards: submit failed — ${f.message}'),
      (_) => AppLogger.d('Flashcards: answer ok q=$quality'),
    );

    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.cards.length) {
      state = state.copyWith(
        results: newResults,
        currentIndex: nextIndex,
        status: FlashcardSessionStatus.finished,
        showBack: false,
      );
    } else {
      state = state.copyWith(
        results: newResults,
        currentIndex: nextIndex,
        showBack: false,
      );
    }
  }

  /// Reset complet (retour à l'écran d'accueil de la session).
  void reset() {
    state = const FlashcardSession(
      cards: [],
      currentIndex: 0,
      results: [],
      status: FlashcardSessionStatus.idle,
    );
  }
}

final flashcardsControllerProvider =
    NotifierProvider<FlashcardsController, FlashcardSession>(
      FlashcardsController.new,
    );
