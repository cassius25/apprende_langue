import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:langapp/core/errors/app_failure.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/storage/drift/app_database.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/utils/result.dart';
import '../../../vocabulary/domain/entities/user_vocabulary_entry.dart';
import '../../../vocabulary/domain/entities/vocabulary_item.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/flashcards_repository.dart';
import '../datasources/flashcards_local_datasource.dart';
import '../datasources/flashcards_remote_datasource.dart';

class FlashcardsRepositoryImpl implements FlashcardsRepository {
  FlashcardsRepositoryImpl({
    required this._remote,
    required this._local,
    required this._db,
    required this._tokens,
    required this._network,
  });

  final FlashcardsRemoteDataSource _remote;
  final FlashcardsLocalDataSource _local;
  final AppDatabase _db;
  final SecureTokenStorage _tokens;
  final NetworkInfo _network;

  @override
  Future<Result<List<Flashcard>>> loadDue({int limit = 50}) async {
    final userId = await _tokens.readUserId();
    if (userId == null) return const Left(UnauthorizedFailure());

    final rows = await _db.vocabularyDao.getDueForReview(userId, limit: limit);
    final cards = <Flashcard>[];
    for (final r in rows) {
      final item = await _buildItem(r.vocabularyId);
      if (item == null) continue;
      final entry = UserVocabularyEntry(
        userVocabularyId: r.id,
        vocabularyId: r.vocabularyId,
        state: vocabularyStateFromString(r.state),
        isFavorite: r.isFavorite,
        repetitions: r.repetitions,
        intervalDays: r.intervalDays,
        easeFactor: r.easeFactor,
        successRate: r.successRate,
        difficulty: r.difficulty,
        nextReviewAt: r.nextReviewAt,
        lastReviewedAt: r.lastReviewedAt,
        item: item,
      );
      cards.add(Flashcard(entry: entry));
    }
    return success(cards);
  }

  Future<VocabularyItem?> _buildItem(String vocabularyId) async {
    final v = await _db.catalogDao.getVocabularyById(vocabularyId);
    if (v == null) return null;
    final ts = await _db.catalogDao.getTranslationsFor(vocabularyId);
    final es = await _db.catalogDao.getExamplesFor(vocabularyId);
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

  @override
  Future<Result<UserVocabularyEntry>> submitAnswer({
    required Flashcard card,
    required int quality,
    int? responseTimeMs,
  }) async {
    final userId = await _tokens.readUserId();
    if (userId == null) return const Left(UnauthorizedFailure());

    if (await _network.isConnected) {
      final remote = await _remote.submitReview(
        userVocabularyId: card.entry.userVocabularyId,
        quality: quality,
        responseTimeMs: responseTimeMs,
      );
      if (remote.isRight()) {
        final serverEntry = remote.valueOrNull!;
        final merged = UserVocabularyEntry(
          userVocabularyId: serverEntry.userVocabularyId,
          vocabularyId: card.entry.vocabularyId,
          state: serverEntry.state,
          isFavorite: card.entry.isFavorite,
          repetitions: serverEntry.repetitions,
          intervalDays: serverEntry.intervalDays,
          easeFactor: serverEntry.easeFactor,
          successRate: serverEntry.successRate,
          difficulty: serverEntry.difficulty,
          nextReviewAt: serverEntry.nextReviewAt,
          lastReviewedAt: DateTime.now(),
          item: card.entry.item,
        );
        await _db.vocabularyDao.upsert(
          LocalUserVocabularyCompanion.insert(
            id: merged.userVocabularyId,
            userId: userId,
            vocabularyId: merged.vocabularyId,
            state: _stateToString(merged.state),
            isFavorite: Value(merged.isFavorite),
            repetitions: Value(merged.repetitions),
            intervalDays: Value(merged.intervalDays),
            easeFactor: Value(merged.easeFactor),
            successRate: Value(merged.successRate),
            difficulty: Value(merged.difficulty),
            nextReviewAt: Value(merged.nextReviewAt),
            lastReviewedAt: Value(merged.lastReviewedAt),
            serverUpdatedAt: DateTime.now(),
          ),
        );
        return success(merged);
      }
    }

    final updated = await _local.applySm2Locally(
      userId: userId,
      userVocabularyId: card.entry.userVocabularyId,
      quality: quality,
    );
    return success(updated.copyWith(item: card.entry.item));
  }

  String _stateToString(VocabularyState s) {
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
}
