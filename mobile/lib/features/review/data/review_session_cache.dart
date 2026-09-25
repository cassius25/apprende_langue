import 'dart:convert';

import 'package:langapp/features/flashcards/domain/entities/flashcard.dart';
import 'package:langapp/features/review/domain/repositories/review_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persiste une session de révision en cours pour reprise après kill.
/// Stocke : cards (id + userVocabularyId), answers, index courant.
class ReviewSessionCache {
  ReviewSessionCache(this._prefs);
  final SharedPreferences _prefs;

  static const _key = 'langapp.review_session';

  Future<void> save({
    required List<Flashcard> cards,
    required List<ReviewAnswer> answers,
    required int currentIndex,
  }) async {
    final data = {
      'currentIndex': currentIndex,
      'cards': cards
          .map(
            (c) => {
              'userVocabularyId': c.entry.userVocabularyId,
              'vocabularyId': c.entry.vocabularyId,
            },
          )
          .toList(),
      'answers': answers
          .map(
            (a) => {
              'userVocabularyId': a.flashcard.entry.userVocabularyId,
              'vocabularyId': a.flashcard.entry.vocabularyId,
              'quality': a.quality,
              'responseTimeMs': a.responseTimeMs,
            },
          )
          .toList(),
      'savedAt': DateTime.now().toIso8601String(),
    };
    await _prefs.setString(_key, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> load() async {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return Map<String, dynamic>.from(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() => _prefs.remove(_key);
}
