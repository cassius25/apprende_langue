import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/result.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/profile_usecases.dart';

final profileRemoteProvider = Provider<ProfileRemoteDataSource>(
  (ref) => ProfileRemoteDataSource(ref.watch(dioProvider)),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(ref.watch(profileRemoteProvider)),
);

final getProfileUseCaseProvider = Provider<GetProfileUseCase>(
  (ref) => GetProfileUseCase(ref.watch(profileRepositoryProvider)),
);
final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>(
  (ref) => UpdateProfileUseCase(ref.watch(profileRepositoryProvider)),
);
final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>(
  (ref) => ChangePasswordUseCase(ref.watch(profileRepositoryProvider)),
);
final deleteAccountUseCaseProvider = Provider<DeleteAccountUseCase>(
  (ref) => DeleteAccountUseCase(ref.watch(profileRepositoryProvider)),
);

// ─── Badges (défini localement — données serveur statiques + earnedAt) ───
class BadgeInfo {
  const BadgeInfo({
    required this.id,
    required this.code,
    required this.name,
    required this.icon,
    this.earnedAt,
  });
  final String id;
  final String code;
  final String name;
  final String? icon;
  final DateTime? earnedAt;

  bool get earned => earnedAt != null;
}

/// Badges gagnés par l'utilisateur (via `SyncQueue`/pull de la Partie 19, ici
/// simplifié : on lit le catalogue Badge et les `LocalUserBadges`).
final badgesProvider = FutureProvider<List<BadgeInfo>>((ref) async {
  // Implémentation simplifiée pour cette partie : renvoie les badges "connus"
  // avec un statut gagné/inconnu basé sur la table locale.
  // La Partie 19 l'enrichira via le pull `/sync`.
  return const <BadgeInfo>[];
});

// ignore: unused_element
void _keepTypes() {
  // évite des warnings d'import inutilisé
  const Result<void> _ = Right(null);
}
