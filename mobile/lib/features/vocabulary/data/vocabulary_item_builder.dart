import '../../../../core/storage/drift/app_database.dart';
import '../domain/entities/vocabulary_item.dart';

/// Point unique de construction d'un `VocabularyItem` à partir de lignes Drift.
/// Utilisé par plusieurs repositories pour éviter la duplication.
class VocabularyItemBuilder {
  const VocabularyItemBuilder._();

  static VocabularyItem build(
    LocalVocabularyData v,
    List<LocalVocabularyTranslation> ts,
    List<LocalVocabularyExample> es,
  ) {
    return VocabularyItem(
      id: v.id,
      word: v.word,
      phonetic: v.phonetic,
      audioUrl: v.audioUrl,
      imageUrl: v.imageUrl,
      category: v.category,
      partOfSpeech: v.partOfSpeech,
      languageId: v.languageId,
      languageCode: '',
      languageName: '',
      translations: ts
          .map(
            (t) => VocabularyTranslation(
              languageId: t.languageId,
              languageCode: t.languageCode,
              languageName: t.languageCode,
              translation: t.translation,
            ),
          )
          .toList(growable: false),
      examples: es
          .map(
            (e) => VocabularyExample(
              sentence: e.sentence,
              translation: e.translation,
              audioUrl: e.audioUrl,
            ),
          )
          .toList(growable: false),
    );
  }
}
