import 'dart:math' as math;

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:langapp/core/errors/app_failure.dart';
import 'package:langapp/features/vocabulary/data/vocabulary_item_builder.dart';
import 'package:langapp/features/vocabulary/domain/entities/vocabulary_item.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/storage/drift/app_database.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/utils/result.dart';
import '../../../flashcards/data/datasources/flashcards_local_datasource.dart';
import '../../../flashcards/domain/entities/flashcard.dart';
import '../../../vocabulary/domain/entities/user_vocabulary_entry.dart';
import '../../domain/entities/review_stats.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_datasource.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl({
    required this._remote,
    required this._flashcardsLocal,
    required this._db,
    required this._tokens,
    required this._network,
  });

  final ReviewRemoteDataSource _remote;
  final FlashcardsLocalDataSource _flashcardsLocal;
  final AppDatabase _db;
  final SecureTokenStorage _tokens;
  final NetworkInfo _network;

  // ─────────────────────────────────────────────────────────
  // File de révision
  // ─────────────────────────────────────────────────────────
  @override
  Future<Result<List<Flashcard>>> loadQueue({
    String? languageId,
    int limit = 20,
    bool includeNew = false,
    bool shuffle = false,
  }) async {
    final userId = await _tokens.readUserId();
    if (userId == null) return const Left(UnauthorizedFailure());

    // 1) Lit les cartes candidates localement.
    final localRows = await _db.vocabularyDao.getDueForReview(
      userId,
      limit: limit * 2,
    );

    // 2) Si inclure NEW, on ajoute les mots d'état NEW (déjà entrés via startLearning).
    List<LocalUserVocabularyData> allRows = localRows;
    if (includeNew) {
      final newRows = await _db.vocabularyDao.getByUser(
        userId,
        state: 'NEW',
        limit: limit,
      );
      allRows = [...localRows, ...newRows];
    }

    // 3) Filtre langue + tri + limite.
    final filtered = <LocalUserVocabularyData>[];
    for (final r in allRows) {
      if (languageId != null) {
        final vocab = await _db.catalogDao.getVocabularyById(r.vocabularyId);
        if (vocab == null || vocab.languageId != languageId) continue;
      }
      filtered.add(r);
      if (filtered.length >= limit) break;
    }

    if (shuffle) {
      filtered.shuffle(math.Random());
    }

    // 4) Hydrate en `Flashcard`.
    final cards = <Flashcard>[];
    for (final r in filtered) {
      final card = await _hydrateCard(r);
      if (card != null) cards.add(card);
    }
    return success(cards);
  }

  @override
  Future<Result<int>> countDue() async {
    final userId = await _tokens.readUserId();
    if (userId == null) return const Left(UnauthorizedFailure());

    // En ligne : compteur serveur (plus fiable)
    if (await _network.isConnected) {
      final remote = await _remote.countDue();
      if (remote.isRight()) return remote;
    }
    // Hors ligne : compteur local
    final count = await _db.vocabularyDao.countDueForReview(userId);
    return success(count);
  }

  @override
  Future<Result<ReviewQueueSummary>> queueSummary() async {
    final userId = await _tokens.readUserId();
    if (userId == null) return const Left(UnauthorizedFailure());

    final all = await _db.vocabularyDao.getByUser(userId, limit: 10000);
    final now = DateTime.now();

    int due = 0, newC = 0, learning = 0, review = 0, mastered = 0;
    for (final r in all) {
      switch (r.state) {
        case 'NEW':
          newC++;
          break;
        case 'LEARNING':
          learning++;
          if (r.nextReviewAt == null || !r.nextReviewAt!.isAfter(now)) due++;
          break;
        case 'REVIEW':
          review++;
          if (r.nextReviewAt == null || !r.nextReviewAt!.isAfter(now)) due++;
          break;
        case 'MASTERED':
          mastered++;
          break;
      }
    }

    return success(
      ReviewQueueSummary(
        dueCount: due,
        newCount: newC,
        learningCount: learning,
        reviewCount: review,
        masteredCount: mastered,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Soumission batch
  // ─────────────────────────────────────────────────────────
  @override
  Future<Result<ReviewSessionStats>> submitBatch(
    List<ReviewAnswer> answers,
  ) async {
    final userId = await _tokens.readUserId();
    if (userId == null) return const Left(UnauthorizedFailure());

    if (answers.isEmpty) {
      return success(const ReviewSessionStats.empty());
    }

    // ─── En ligne : serveur autoritaire
    if (await _network.isConnected) {
      final remote = await _remote.submitBatch(answers);
      if (remote.isRight()) {
        final serverEntries = remote.valueOrNull!;
        // Mappe par userVocabularyId pour récupérer le vocabularyId local.
        final byUserVocabId = {
          for (final a in answers)
            a.flashcard.entry.userVocabularyId: a.flashcard.entry,
        };

        // Écrit dans Drift.
        for (final entry in serverEntries) {
          final local = byUserVocabId[entry.userVocabularyId];
          if (local == null) continue;
          final merged = entry.copyWith(item: local.item);
          await _db.vocabularyDao.upsert(
            LocalUserVocabularyCompanion.insert(
              id: merged.userVocabularyId,
              userId: userId,
              vocabularyId: local.vocabularyId,
              state: _stateToString(merged.state),
              isFavorite: Value(local.isFavorite),
              repetitions: Value(merged.repetitions),
              intervalDays: Value(merged.intervalDays),
              easeFactor: Value(merged.easeFactor),
              successRate: Value(merged.successRate),
              difficulty: Value(merged.difficulty),
              nextReviewAt: Value(merged.nextReviewAt),
              lastReviewedAt: Value(DateTime.now()),
              serverUpdatedAt: DateTime.now(),
            ),
          );
        }

        final info = _remote.consumeLastBatchInfo();
        return success(
          _buildStats(answers, serverXp: info?.xpEarned, info: info),
        );
      }
      // Erreur réseau : on bascule sur le mode offline.
    }

    // ─── Hors ligne : SM-2 local + enqueue
    for (final a in answers) {
      await _flashcardsLocal.applySm2Locally(
        userId: userId,
        userVocabularyId: a.flashcard.entry.userVocabularyId,
        quality: a.quality,
      );
    }
    return success(_buildStats(answers, serverXp: null, offline: true));
  }

  // ─────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────
  Future<Flashcard?> _hydrateCard(LocalUserVocabularyData r) async {
    final v = await _db.catalogDao.getVocabularyById(r.vocabularyId);
    if (v == null) return null;
    final ts = await _db.catalogDao.getTranslationsFor(r.vocabularyId);
    final es = await _db.catalogDao.getExamplesFor(r.vocabularyId);

    final item = _buildItem(v, ts, es);

    return Flashcard(
      entry: UserVocabularyEntry(
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
      ),
    );
  }

  VocabularyItem _buildItem(
    LocalVocabularyData v,
    List<LocalVocabularyTranslation> ts,
    List<LocalVocabularyExample> es,
  ) {
    // import paresseux du type pour éviter un import circulaire : on utilise
    // directement les types de vocabulary/domain.
    return _VocabularyItemFactory.build(v, ts, es);
  }

  ReviewSessionStats _buildStats(
    List<ReviewAnswer> answers, {
    required int? serverXp,
    BatchInfo? info,
    bool offline = false,
  }) {
    final total = answers.length;
    final correct = answers.where((a) => a.quality >= 3).length;
    final wrong = total - correct;
    final sumQ = answers.fold<int>(0, (s, a) => s + a.quality);
    final avgQ = total == 0 ? 0.0 : sumQ / total;
    final responsesWithTime = answers
        .where((a) => a.responseTimeMs != null)
        .toList();
    final avgMs = responsesWithTime.isEmpty
        ? 0
        : (responsesWithTime.fold<int>(0, (s, a) => s + a.responseTimeMs!) /
                  responsesWithTime.length)
              .round();

    // XP local (miroir du backend) si offline : 2 XP échec, 5-7 XP succès.
    int xp;
    if (serverXp != null) {
      xp = serverXp;
    } else {
      xp = answers.fold<int>(0, (s, a) {
        if (a.quality < 3) return s + 2;
        return s + 5 + (a.quality - 3);
      });
    }

    return ReviewSessionStats(
      totalCards: total,
      answered: total,
      correct: correct,
      wrong: wrong,
      averageQuality: double.parse(avgQ.toStringAsFixed(2)),
      averageResponseMs: avgMs,
      xpEarned: xp,
      totalXp: info?.totalXp ?? 0,
      userLevel: info?.userLevel ?? 1,
      streakCurrent: info?.streakCurrent ?? 0,
      streakLongest: info?.streakLongest ?? 0,
      newBadges: info?.newBadges ?? const [],
      offlineQueued: offline,
    );
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

/// Factory isolée pour construire un `VocabularyItem` (évite les imports circulaires).
class _VocabularyItemFactory {
  static VocabularyItem build(
    LocalVocabularyData v,
    List<LocalVocabularyTranslation> ts,
    List<LocalVocabularyExample> es,
  ) {
    return VocabularyItemBuilder.build(v, ts, es);
  }
}
