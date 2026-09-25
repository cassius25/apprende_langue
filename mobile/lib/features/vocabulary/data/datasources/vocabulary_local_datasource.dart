import 'package:drift/drift.dart';

import '../../../../core/storage/drift/app_database.dart';
import '../../domain/entities/user_vocabulary_entry.dart';
import '../../domain/entities/vocabulary_item.dart';

/// Lecture/écriture Drift pour vocabulaire + traductions + exemples + user_vocabulary.
class VocabularyLocalDataSource {
  VocabularyLocalDataSource(this._db);
  final AppDatabase _db;

  // ─────────────────────────────────────────────────────────
  // Catalogue
  // ─────────────────────────────────────────────────────────
  Future<void> cacheCatalogItems(List<VocabularyItem> items) async {
    await _db.transaction(() async {
      final now = DateTime.now();
      await _db.catalogDao.upsertVocabulary([
        for (final it in items)
          LocalVocabularyCompanion.insert(
            id: it.id,
            languageId: it.languageId,
            levelId: '',
            word: it.word,
            phonetic: Value(it.phonetic),
            audioUrl: Value(it.audioUrl),
            imageUrl: Value(it.imageUrl),
            category: Value(it.category),
            partOfSpeech: Value(it.partOfSpeech),
            serverUpdatedAt: now,
          ),
      ]);

      final translations = <LocalVocabularyTranslationsCompanion>[];
      final examples = <LocalVocabularyExamplesCompanion>[];
      for (final it in items) {
        for (var i = 0; i < it.translations.length; i++) {
          final t = it.translations[i];
          translations.add(
            LocalVocabularyTranslationsCompanion.insert(
              id: '${it.id}_${t.languageCode}',
              vocabularyId: it.id,
              languageId: t.languageId,
              languageCode: t.languageCode,
              translation: t.translation,
            ),
          );
        }
        for (var i = 0; i < it.examples.length; i++) {
          final e = it.examples[i];
          examples.add(
            LocalVocabularyExamplesCompanion.insert(
              id: '${it.id}_ex_$i',
              vocabularyId: it.id,
              sentence: e.sentence,
              translation: Value(e.translation),
              audioUrl: Value(e.audioUrl),
              order: Value(i),
            ),
          );
        }
      }
      if (translations.isNotEmpty) {
        await _db.catalogDao.upsertTranslations(translations);
      }
      if (examples.isNotEmpty) {
        await _db.catalogDao.upsertExamples(examples);
      }
    });
  }

  Future<List<VocabularyItem>> readCatalog({
    String? languageId,
    String? search,
    int limit = 200,
  }) async {
    final rows = await _db.catalogDao.searchVocabulary(
      languageId: languageId,
      search: search,
      limit: limit,
    );
    return Future.wait(
      rows.map((r) async {
        final translations = await _db.catalogDao.getTranslationsFor(r.id);
        final examples = await _db.catalogDao.getExamplesFor(r.id);
        return VocabularyItem(
          id: r.id,
          word: r.word,
          phonetic: r.phonetic,
          audioUrl: r.audioUrl,
          imageUrl: r.imageUrl,
          category: r.category,
          partOfSpeech: r.partOfSpeech,
          languageId: r.languageId,
          languageCode: '',
          languageName: '',
          translations: translations
              .map(
                (t) => VocabularyTranslation(
                  languageId: t.languageId,
                  languageCode: t.languageCode,
                  languageName: t.languageCode,
                  translation: t.translation,
                ),
              )
              .toList(growable: false),
          examples: examples
              .map(
                (e) => VocabularyExample(
                  sentence: e.sentence,
                  translation: e.translation,
                  audioUrl: e.audioUrl,
                ),
              )
              .toList(growable: false),
        );
      }),
    );
  }

  Future<VocabularyItem?> readOne(String id) async {
    final r = await _db.catalogDao.getVocabularyById(id);
    if (r == null) return null;
    final translations = await _db.catalogDao.getTranslationsFor(id);
    final examples = await _db.catalogDao.getExamplesFor(id);
    return VocabularyItem(
      id: r.id,
      word: r.word,
      phonetic: r.phonetic,
      audioUrl: r.audioUrl,
      imageUrl: r.imageUrl,
      category: r.category,
      partOfSpeech: r.partOfSpeech,
      languageId: r.languageId,
      languageCode: '',
      languageName: '',
      translations: translations
          .map(
            (t) => VocabularyTranslation(
              languageId: t.languageId,
              languageCode: t.languageCode,
              languageName: t.languageCode,
              translation: t.translation,
            ),
          )
          .toList(growable: false),
      examples: examples
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

  // ─────────────────────────────────────────────────────────
  // User vocabulary
  // ─────────────────────────────────────────────────────────
  Future<void> upsertUserEntry(
    UserVocabularyEntry e, {
    required String userId,
  }) async {
    await _db.vocabularyDao.upsert(
      LocalUserVocabularyCompanion.insert(
        id: e.userVocabularyId,
        userId: userId,
        vocabularyId: e.vocabularyId,
        state: vocabularyStateToString(e.state),
        isFavorite: Value(e.isFavorite),
        repetitions: Value(e.repetitions),
        intervalDays: Value(e.intervalDays),
        easeFactor: Value(e.easeFactor),
        successRate: Value(e.successRate),
        difficulty: Value(e.difficulty),
        nextReviewAt: Value(e.nextReviewAt),
        lastReviewedAt: Value(e.lastReviewedAt),
        serverUpdatedAt: DateTime.now(),
      ),
    );
  }

  Future<List<LocalUserVocabularyData>> readUserRows({
    required String userId,
    String? state,
    bool? isFavorite,
    int limit = 200,
  }) {
    return _db.vocabularyDao.getByUser(
      userId,
      state: state,
      isFavorite: isFavorite,
      limit: limit,
    );
  }

  Future<LocalUserVocabularyData?> readUserEntry(
    String userId,
    String vocabularyId,
  ) {
    return _db.vocabularyDao.getByVocabularyId(userId, vocabularyId);
  }

  Future<List<LocalUserVocabularyData>> readDueForReview(
    String userId, {
    int limit = 50,
  }) {
    return _db.vocabularyDao.getDueForReview(userId, limit: limit);
  }

  Future<int> countDueForReview(String userId) {
    return _db.vocabularyDao.countDueForReview(userId);
  }
}
