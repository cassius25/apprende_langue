import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:langapp/core/utils/logger.dart';
import 'package:langapp/core/utils/result.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_providers.dart';

// ─────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────

enum AuthStatus { unknown, unauthenticated, authenticated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final AuthStatus status;
  final UserProfile? user;
  final bool isSubmitting;
  final String? errorMessage;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;

  AuthState copyWith({
    AuthStatus? status,
    UserProfile? user,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, user, isSubmitting, errorMessage];
}

// ─────────────────────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────────────────────

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState(status: AuthStatus.unknown);
  }

  // ─────────────────────────────────────────────────────────
  // Bootstrap
  // ─────────────────────────────────────────────────────────
  /// Appelé par `SplashPage`. Décide de l'état initial.
  Future<void> bootstrap() async {
    final repo = ref.read(authRepositoryProvider);

    // 1) Pas de tokens → unauthenticated
    final hasTokens = await repo.hasTokens();
    if (!hasTokens) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
      );
      return;
    }

    // 2) Tokens présents → on lit le profil local pour un affichage instantané
    final localProfile = await repo.readLocalProfile();
    if (localProfile != null) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: localProfile,
      );
    }

    // 3) Refresh serveur (silencieux) pour valider la session
    final result = await ref.read(getMeUseCaseProvider).call();
    if (result.isLeft()) {
      final failure = result.failureOrNull!;
      AppLogger.w('Bootstrap getMe échoué: ${failure.message}');
      // Si le profil local existait, on garde la session (mode offline).
      // Sinon on déconnecte.
      if (localProfile == null) {
        await repo.purgeLocalSession();
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
      return;
    }
    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: result.valueOrNull,
    );
  }

  // ─────────────────────────────────────────────────────────
  // Login
  // ─────────────────────────────────────────────────────────
  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    final result = await ref
        .read(loginUseCaseProvider)
        .call(email: email, password: password);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (auth) {
        state = AuthState(
          status: AuthStatus.authenticated,
          user: auth.user,
          isSubmitting: false,
        );
        return true;
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  // Register
  // ─────────────────────────────────────────────────────────
  Future<bool> register(RegisterParams params) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    final result = await ref.read(registerUseCaseProvider).call(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (auth) {
        state = AuthState(
          status: AuthStatus.authenticated,
          user: auth.user,
          isSubmitting: false,
        );
        return true;
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  // Logout
  // ─────────────────────────────────────────────────────────
  Future<void> logout() async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    await ref.read(logoutUseCaseProvider).call();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  // ─────────────────────────────────────────────────────────
  // Forgot / Reset / Verify
  // ─────────────────────────────────────────────────────────
  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    final result = await ref.read(forgotPasswordUseCaseProvider).call(email);
    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(isSubmitting: false);
        return true;
      },
    );
  }

  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    final result = await ref
        .read(resetPasswordUseCaseProvider)
        .call(token: token, newPassword: newPassword);
    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(isSubmitting: false);
        return true;
      },
    );
  }

  Future<bool> verifyEmail(String token) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    final result = await ref.read(verifyEmailUseCaseProvider).call(token);
    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) async {
        // Rafraîchit le profil (emailVerified = true désormais).
        final meResult = await ref.read(getMeUseCaseProvider).call();
        if (meResult.isRight()) {
          state = state.copyWith(
            user: meResult.valueOrNull,
            isSubmitting: false,
          );
        } else {
          state = state.copyWith(isSubmitting: false);
        }
        return true;
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  // Session expirée (déclenché par AuthInterceptor)
  // ─────────────────────────────────────────────────────────
  Future<void> handleSessionExpired() async {
    AppLogger.w('AuthController: session expirée — purge locale');
    await ref.read(authRepositoryProvider).purgeLocalSession();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  // ─────────────────────────────────────────────────────────
  // Utilitaires UI
  // ─────────────────────────────────────────────────────────
  void clearError() {
    if (state.errorMessage == null) return;
    state = state.copyWith(clearError: true);
  }

  /// Rafraîchit le profil (utile après onboarding ou mise à jour manuelle).
  Future<void> refreshProfile() async {
    final result = await ref.read(getMeUseCaseProvider).call();
    if (result.isRight()) {
      state = state.copyWith(user: result.valueOrNull);
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Providers dérivés
// ─────────────────────────────────────────────────────────────

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// Profil courant (null si non connecté).
final currentUserProvider = Provider<UserProfile?>((ref) {
  return ref.watch(authControllerProvider).user;
});

/// `true` si authentifié (session valide).
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authControllerProvider).isAuthenticated;
});

/// Dernière erreur (utilisée pour les snackbars).
final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authControllerProvider).errorMessage;
});

/// Indicateur de chargement des actions auth.
final authSubmittingProvider = Provider<bool>((ref) {
  return ref.watch(authControllerProvider).isSubmitting;
});
