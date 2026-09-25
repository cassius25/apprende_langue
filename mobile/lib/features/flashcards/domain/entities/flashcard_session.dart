import 'package:equatable/equatable.dart';

import 'flashcard.dart';

enum FlashcardSessionStatus { idle, running, finished }

class FlashcardResult {
  const FlashcardResult({
    required this.flashcard,
    required this.quality,
    required this.isCorrect,
  });

  final Flashcard flashcard;
  final int quality; // 0..5
  final bool isCorrect;
}

class FlashcardSession extends Equatable {
  const FlashcardSession({
    required this.cards,
    required this.currentIndex,
    required this.results,
    required this.status,
    this.showBack = false,
  });

  final List<Flashcard> cards;
  final int currentIndex;
  final List<FlashcardResult> results;
  final FlashcardSessionStatus status;
  final bool showBack;

  Flashcard? get current =>
      (status == FlashcardSessionStatus.running && currentIndex < cards.length)
      ? cards[currentIndex]
      : null;

  int get total => cards.length;
  int get completed => results.length;
  double get progress => total == 0 ? 0 : completed / total;

  int get correctCount => results.where((r) => r.isCorrect).length;

  FlashcardSession copyWith({
    int? currentIndex,
    List<FlashcardResult>? results,
    FlashcardSessionStatus? status,
    bool? showBack,
  }) {
    return FlashcardSession(
      cards: cards,
      currentIndex: currentIndex ?? this.currentIndex,
      results: results ?? this.results,
      status: status ?? this.status,
      showBack: showBack ?? this.showBack,
    );
  }

  @override
  List<Object?> get props => [currentIndex, results.length, status, showBack];
}
