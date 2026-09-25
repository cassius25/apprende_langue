import 'package:equatable/equatable.dart';

class VocabularyTranslation extends Equatable {
  const VocabularyTranslation({
    required this.languageId,
    required this.languageCode,
    required this.languageName,
    required this.translation,
  });

  final String languageId;
  final String languageCode;
  final String languageName;
  final String translation;

  @override
  List<Object?> get props => [languageId, languageCode, translation];
}

class VocabularyExample extends Equatable {
  const VocabularyExample({
    required this.sentence,
    this.translation,
    this.audioUrl,
  });

  final String sentence;
  final String? translation;
  final String? audioUrl;

  @override
  List<Object?> get props => [sentence, translation, audioUrl];
}

/// Mot du catalogue (contenu backend, lecture seule).
class VocabularyItem extends Equatable {
  const VocabularyItem({
    required this.id,
    required this.word,
    required this.languageCode,
    required this.languageName,
    required this.languageId,
    this.languageFlagEmoji,
    this.phonetic,
    this.audioUrl,
    this.imageUrl,
    this.category,
    this.partOfSpeech,
    this.levelCode,
    this.translations = const [],
    this.examples = const [],
  });

  final String id;
  final String word;
  final String? phonetic;
  final String? audioUrl;
  final String? imageUrl;
  final String? category;
  final String? partOfSpeech;
  final String languageId;
  final String languageCode;
  final String languageName;
  final String? languageFlagEmoji;
  final String? levelCode;
  final List<VocabularyTranslation> translations;
  final List<VocabularyExample> examples;

  @override
  List<Object?> get props => [id, word, languageCode];
}
