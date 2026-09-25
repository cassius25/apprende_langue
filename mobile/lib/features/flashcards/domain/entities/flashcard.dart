import 'package:equatable/equatable.dart';

import '../../../vocabulary/domain/entities/user_vocabulary_entry.dart';

/// Une flashcard unitaire (word + back).
class Flashcard extends Equatable {
  const Flashcard({required this.entry});
  final UserVocabularyEntry entry;

  String get front => entry.item?.word ?? '';

  String? get phonetic => entry.item?.phonetic;

  String? get audioUrl => entry.item?.audioUrl;

  String get translation => entry.item?.translations.isNotEmpty == true
      ? entry.item!.translations.first.translation
      : '';

  String? get example {
    final ex = entry.item?.examples ?? const [];
    return ex.isNotEmpty ? ex.first.sentence : null;
  }

  String? get exampleTranslation {
    final ex = entry.item?.examples ?? const [];
    return ex.isNotEmpty ? ex.first.translation : null;
  }

  @override
  List<Object?> get props => [entry.userVocabularyId];
}
