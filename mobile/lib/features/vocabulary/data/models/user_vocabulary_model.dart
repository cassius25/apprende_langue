import '../../domain/entities/user_vocabulary_entry.dart';

class UserVocabularyModel {
  const UserVocabularyModel({required this.json});
  final Map<String, dynamic> json;

  factory UserVocabularyModel.fromApi(Map<String, dynamic> json) =>
      UserVocabularyModel(json: json);

  UserVocabularyEntry toEntity() {
    return UserVocabularyEntry(
      userVocabularyId: json['id'] as String,
      vocabularyId: json['vocabularyId'] as String,
      state: vocabularyStateFromString(json['state'] as String? ?? 'NEW'),
      isFavorite: json['isFavorite'] as bool? ?? false,
      repetitions: (json['repetitions'] as num?)?.toInt() ?? 0,
      intervalDays: (json['intervalDays'] as num?)?.toInt() ?? 0,
      easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
      successRate: (json['successRate'] as num?)?.toDouble() ?? 0,
      difficulty: (json['difficulty'] as num?)?.toDouble() ?? 0,
      nextReviewAt: _parse(json['nextReviewAt']),
      lastReviewedAt: _parse(json['lastReviewedAt']),
    );
  }

  static DateTime? _parse(Object? raw) {
    if (raw is! String || raw.isEmpty) return null;
    return DateTime.tryParse(raw)?.toLocal();
  }
}
