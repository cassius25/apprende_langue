import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/auth_interceptor.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../storage/preferences.dart';
import '../storage/secure_storage.dart';
import '../utils/logger.dart';

// ─────────────────────────────────────────────────────────────
// Storage
// ─────────────────────────────────────────────────────────────

final secureTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  return SecureTokenStorage();
});

/// Override dans `main.dart` après `AppPreferences.load()`.
final appPreferencesProvider = Provider<AppPreferences>((ref) {
  throw UnimplementedError(
    'appPreferencesProvider doit être overridé dans ProviderScope '
    '(voir main.dart → AppPreferences.load()).',
  );
});

// ─────────────────────────────────────────────────────────────
// Network
// ─────────────────────────────────────────────────────────────

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.watch(connectivityProvider));
});

/// Flux de connectivité exposé à l'UI (utile pour la bannière « hors ligne »).
final isConnectedProvider = StreamProvider<bool>((ref) {
  final info = ref.watch(networkInfoProvider);
  // Émet immédiatement l'état courant, puis les changements.
  return info.onStatusChange;
});

/// Callback global « session expirée ».
/// Le feature Auth le surchargera en Partie 13 pour naviguer vers /login.
/// Ici, on log seulement.
final onSessionExpiredProvider = Provider<OnSessionExpired>((ref) {
  return () => AppLogger.w('Session expirée — tokens purgés');
});

/// Dio principal, utilisé par tous les repositories.
final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(secureTokenStorageProvider);
  final onSessionExpired = ref.watch(onSessionExpiredProvider);

  final dio = DioClient.build(
    tokenStorage: tokenStorage,
    onSessionExpired: onSessionExpired,
  );

  ref.onDispose(dio.close);
  return dio;
});
