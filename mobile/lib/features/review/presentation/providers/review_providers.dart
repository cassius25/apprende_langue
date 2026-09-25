import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/drift/providers.dart';
import '../../../flashcards/data/datasources/flashcards_local_datasource.dart';
import '../../data/datasources/review_remote_datasource.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../data/review_session_cache.dart';
import '../../domain/entities/review_stats.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/usecases/review_usecases.dart';

// ─────────────────────────────────────────────────────────────
// Data sources
// ─────────────────────────────────────────────────────────────

final reviewRemoteProvider = Provider<ReviewRemoteDataSource>(
  (ref) => ReviewRemoteDataSource(ref.watch(dioProvider)),
);

final flashcardsLocalProvider = Provider<FlashcardsLocalDataSource>(
  (ref) => FlashcardsLocalDataSource(ref.watch(appDatabaseProvider)),
);

// ─────────────────────────────────────────────────────────────
// Repository
// ─────────────────────────────────────────────────────────────

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(
    remote: ref.watch(reviewRemoteProvider),
    flashcardsLocal: ref.watch(flashcardsLocalProvider),
    db: ref.watch(appDatabaseProvider),
    tokens: ref.watch(secureTokenStorageProvider),
    network: ref.watch(networkInfoProvider),
  );
});

// ─────────────────────────────────────────────────────────────
// Use cases
// ─────────────────────────────────────────────────────────────

final loadReviewQueueUseCaseProvider = Provider<LoadReviewQueueUseCase>(
  (ref) => LoadReviewQueueUseCase(ref.watch(reviewRepositoryProvider)),
);

final countDueReviewsUseCaseProvider = Provider<CountDueReviewsUseCase>(
  (ref) => CountDueReviewsUseCase(ref.watch(reviewRepositoryProvider)),
);

final reviewQueueSummaryUseCaseProvider = Provider<ReviewQueueSummaryUseCase>(
  (ref) => ReviewQueueSummaryUseCase(ref.watch(reviewRepositoryProvider)),
);

final submitReviewBatchUseCaseProvider = Provider<SubmitReviewBatchUseCase>(
  (ref) => SubmitReviewBatchUseCase(ref.watch(reviewRepositoryProvider)),
);

// ─────────────────────────────────────────────────────────────
// Cache de session
// ─────────────────────────────────────────────────────────────

final reviewSessionCacheProvider = Provider<ReviewSessionCache>((ref) {
  final prefs = ref.watch(appPreferencesProvider);
  // AppPreferences encapsule déjà SharedPreferences.
  // On expose un accès direct via le cache.
  return ReviewSessionCache(prefs.raw);
});

// ─────────────────────────────────────────────────────────────
// Providers réactifs
// ─────────────────────────────────────────────────────────────

/// Compteur de révisions dues (badge onglet Réviser).
final dueReviewCountProvider = FutureProvider<int>((ref) async {
  final result = await ref.watch(countDueReviewsUseCaseProvider).call();
  return result.fold((f) => 0, (v) => v);
});

/// Résumé de la file (pour l'écran ReviewHomePage).
final reviewQueueSummaryProvider = FutureProvider<ReviewQueueSummary>((
  ref,
) async {
  final result = await ref.watch(reviewQueueSummaryUseCaseProvider).call();
  return result.fold((f) => const ReviewQueueSummary.empty(), (v) => v);
});
