import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/drift/providers.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/flashcards_local_datasource.dart';
import '../../data/datasources/flashcards_remote_datasource.dart';
import '../../data/repositories/flashcards_repository_impl.dart';
import '../../domain/repositories/flashcards_repository.dart';
import '../../domain/usecases/flashcards_usecases.dart';

final flashcardsRemoteDataSourceProvider = Provider<FlashcardsRemoteDataSource>(
  (ref) {
    return FlashcardsRemoteDataSource(ref.watch(dioProvider));
  },
);

final flashcardsLocalDataSourceProvider = Provider<FlashcardsLocalDataSource>((
  ref,
) {
  return FlashcardsLocalDataSource(ref.watch(appDatabaseProvider));
});

final flashcardsRepositoryProvider = Provider<FlashcardsRepository>((ref) {
  return FlashcardsRepositoryImpl(
    remote: ref.watch(flashcardsRemoteDataSourceProvider),
    local: ref.watch(flashcardsLocalDataSourceProvider),
    db: ref.watch(appDatabaseProvider),
    tokens: ref.watch(secureTokenStorageProvider),
    network: ref.watch(networkInfoProvider),
  );
});

final loadFlashcardsUseCaseProvider = Provider<LoadFlashcardsUseCase>(
  (ref) => LoadFlashcardsUseCase(ref.watch(flashcardsRepositoryProvider)),
);

final submitFlashcardAnswerUseCaseProvider =
    Provider<SubmitFlashcardAnswerUseCase>(
      (ref) =>
          SubmitFlashcardAnswerUseCase(ref.watch(flashcardsRepositoryProvider)),
    );

// Réexport pour éviter d'importer plusieurs fichiers.
typedef FlashcardsNetworkInfo = NetworkInfo;
typedef FlashcardsTokens = SecureTokenStorage;
