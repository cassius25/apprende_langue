import 'package:equatable/equatable.dart';

import 'vocabulary_item.dart';

enum VocabularyState { fresh, learning, review, mastered }

class UserVocabularyEntry extends Equatable {
  const UserVocabularyEntry({
    required this.userVocabularyId,
    required this.vocabularyId,
    required this.state,
    required this.isFavorite,
    required this.repetitions,
    required this.intervalDays,
    required this.easeFactor,
    required this.successRate,
    required this.difficulty,
    this.nextReviewAt,
    this.lastReviewedAt,
    this.item,
  });

  final String userVocabularyId;
  final String vocabularyId;
  final VocabularyState state;
  final bool isFavorite;
  final int repetitions;
  final int intervalDays;
  final double easeFactor;
  final double successRate;
  final double difficulty;
  final DateTime? nextReviewAt;
  final DateTime? lastReviewedAt;

  /// Mot complet (peuplé par le repository en joignant le catalogue local).
  final VocabularyItem? item;

  bool get isDueNow {
    if (state != VocabularyState.learning && state != VocabularyState.review) {
      return false;
    }
    if (nextReviewAt == null) return true;
    return !nextReviewAt!.isAfter(DateTime.now());
  }

  UserVocabularyEntry copyWith({VocabularyItem? item, bool? isFavorite}) {
    return UserVocabularyEntry(
      userVocabularyId: userVocabularyId,
      vocabularyId: vocabularyId,
      state: state,
      isFavorite: isFavorite ?? this.isFavorite,
      repetitions: repetitions,
      intervalDays: intervalDays,
      easeFactor: easeFactor,
      successRate: successRate,
      difficulty: difficulty,
      nextReviewAt: nextReviewAt,
      lastReviewedAt: lastReviewedAt,
      item: item ?? this.item,
    );
  }

  @override
  List<Object?> get props => [
    userVocabularyId,
    state,
    isFavorite,
    nextReviewAt,
  ];
}

VocabularyState vocabularyStateFromString(String raw) {
  switch (raw) {
    case 'LEARNING':
      return VocabularyState.learning;
    case 'REVIEW':
      return VocabularyState.review;
    case 'MASTERED':
      return VocabularyState.mastered;
    default:
      return VocabularyState.fresh;
  }
}

String vocabularyStateToString(VocabularyState s) {
  switch (s) {
    case VocabularyState.fresh:
      return 'NEW';
    case VocabularyState.learning:
      return 'LEARNING';
    case VocabularyState.review:
      return 'REVIEW';
    case VocabularyState.mastered:
      return 'MASTERED';
  }
}
