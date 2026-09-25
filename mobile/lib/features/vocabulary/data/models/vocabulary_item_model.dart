import '../../domain/entities/vocabulary_item.dart';

class VocabularyItemModel {
  const VocabularyItemModel({required this.json});
  final Map<String, dynamic> json;

  factory VocabularyItemModel.fromApi(Map<String, dynamic> json) =>
      VocabularyItemModel(json: json);

  VocabularyItem toEntity() {
    final lang = json['language'] as Map<String, dynamic>? ?? const {};
    final level = json['level'] as Map<String, dynamic>?;
    final translations = (json['translations'] as List?) ?? const [];
    final examples = (json['examples'] as List?) ?? const [];

    return VocabularyItem(
      id: json['id'] as String,
      word: json['word'] as String,
      phonetic: json['phonetic'] as String?,
      audioUrl: json['audioUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String?,
      partOfSpeech: json['partOfSpeech'] as String?,
      languageId: lang['id'] as String? ?? '',
      languageCode: lang['code'] as String? ?? '',
      languageName: lang['name'] as String? ?? '',
      languageFlagEmoji: lang['flagEmoji'] as String?,
      levelCode: level?['code'] as String?,
      translations: translations
          .whereType<Map>()
          .map(
            (t) => VocabularyTranslation(
              languageId: t['languageId'] as String? ?? '',
              languageCode: t['languageCode'] as String? ?? '',
              languageName: t['languageName'] as String? ?? '',
              translation: t['translation'] as String? ?? '',
            ),
          )
          .toList(growable: false),
      examples: examples
          .whereType<Map>()
          .map(
            (e) => VocabularyExample(
              sentence: e['sentence'] as String? ?? '',
              translation: e['translation'] as String?,
              audioUrl: e['audioUrl'] as String?,
            ),
          )
          .toList(growable: false),
    );
  }
}
