import 'package:equatable/equatable.dart';

enum ExerciseType {
  multipleChoice,
  translation,
  fillInTheBlank,
  matching,
  wordOrder,
  listening,
  pronunciation;

  static ExerciseType parse(String raw) {
    switch (raw) {
      case 'MULTIPLE_CHOICE':
        return ExerciseType.multipleChoice;
      case 'TRANSLATION':
        return ExerciseType.translation;
      case 'FILL_IN_THE_BLANK':
        return ExerciseType.fillInTheBlank;
      case 'MATCHING':
        return ExerciseType.matching;
      case 'WORD_ORDER':
        return ExerciseType.wordOrder;
      case 'LISTENING':
        return ExerciseType.listening;
      case 'PRONUNCIATION':
        return ExerciseType.pronunciation;
      default:
        return ExerciseType.multipleChoice;
    }
  }

  String toApiString() {
    switch (this) {
      case ExerciseType.multipleChoice:
        return 'MULTIPLE_CHOICE';
      case ExerciseType.translation:
        return 'TRANSLATION';
      case ExerciseType.fillInTheBlank:
        return 'FILL_IN_THE_BLANK';
      case ExerciseType.matching:
        return 'MATCHING';
      case ExerciseType.wordOrder:
        return 'WORD_ORDER';
      case ExerciseType.listening:
        return 'LISTENING';
      case ExerciseType.pronunciation:
        return 'PRONUNCIATION';
    }
  }

  bool get isChoiceBased =>
      this == ExerciseType.multipleChoice ||
      this == ExerciseType.fillInTheBlank ||
      this == ExerciseType.listening;
}

class ExerciseOption extends Equatable {
  const ExerciseOption({required this.id, required this.label, this.order = 0});

  final String id;
  final String label;
  final int order;

  @override
  List<String> get props => [id, label];
}

class Exercise extends Equatable {
  const Exercise({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.question,
    this.data,
    this.order = 0,
    this.options = const [],
  });

  final String id;
  final String lessonId;
  final ExerciseType type;
  final String question;
  final Map<String, dynamic>? data;
  final int order;
  final List<ExerciseOption> options;

  /// Utilitaires pour les types spécifiques.
  List<MatchingPair> get matchingPairs {
    final raw = data?['pairs'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(
          (m) => MatchingPair(
            left: m['left'] as String? ?? '',
            right: m['right'] as String? ?? '',
          ),
        )
        .where((p) => p.left.isNotEmpty && p.right.isNotEmpty)
        .toList(growable: false);
  }

  /// `data.words` — utilisé pour WORD_ORDER (mots mélangés à remettre dans l'ordre).
  List<String> get scrambledWords {
    final raw = data?['words'];
    if (raw is! List) return const [];
    return raw.whereType<String>().toList(growable: false);
  }

  /// `data.audioUrl` — utilisé pour LISTENING / PRONUNCIATION.
  String? get audioUrl => data?['audioUrl'] as String?;

  @override
  List<Object?> get props => [id, type, order];
}

class MatchingPair extends Equatable {
  const MatchingPair({required this.left, required this.right});
  final String left;
  final String right;

  @override
  List<String> get props => [left, right];
}
