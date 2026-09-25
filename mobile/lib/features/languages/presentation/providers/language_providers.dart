import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/drift/providers.dart';
import '../../data/datasources/language_local_datasource.dart';
import '../../data/datasources/language_remote_datasource.dart';
import '../../data/repositories/language_repository_impl.dart';
import '../../domain/entities/language.dart';
import '../../domain/repositories/language_repository.dart';
import '../../domain/usecases/language_usecases.dart';

final languageRemoteProvider = Provider<LanguageRemoteDataSource>(
  (ref) => LanguageRemoteDataSource(ref.watch(dioProvider)),
);

final languageLocalProvider = Provider<LanguageLocalDataSource>(
  (ref) => LanguageLocalDataSource(ref.watch(appDatabaseProvider)),
);

final languageRepositoryProvider = Provider<LanguageRepository>((ref) {
  return LanguageRepositoryImpl(
    remote: ref.watch(languageRemoteProvider),
    local: ref.watch(languageLocalProvider),
    network: ref.watch(networkInfoProvider),
  );
});

final listLanguagesUseCaseProvider = Provider<ListLanguagesUseCase>(
  (ref) => ListLanguagesUseCase(ref.watch(languageRepositoryProvider)),
);

final allLanguagesProvider = FutureProvider<List<Language>>((ref) async {
  final result = await ref.watch(listLanguagesUseCaseProvider).call();
  return result.fold((f) => throw f, (v) => v);
});

/// Langue par code (utilisé pour reconstituer un affichage rapide).
final languageByCodeProvider = Provider.family<Language?, String>((ref, code) {
  final async = ref.watch(allLanguagesProvider);
  return async.maybeWhen(
    data: (list) => list.where((l) => l.code == code).firstOrNull,
    orElse: () => null,
  );
});
