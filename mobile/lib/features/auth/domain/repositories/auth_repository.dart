import 'package:langapp/core/utils/result.dart';

import '../entities/auth_tokens.dart';
import '../entities/user_profile.dart';

/// Paramètres d'inscription.
class RegisterParams {
  const RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.nativeLanguageId,
    this.learningLanguageId,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? nativeLanguageId;
  final String? learningLanguageId;
}

/// Résultat d'authentification (register / login).
class AuthResult {
  const AuthResult({required this.user, required this.tokens});
  final UserProfile user;
  final AuthTokens tokens;
}

abstract class AuthRepository {
  /// Inscription.
  Future<Result<AuthResult>> register(RegisterParams params);

  /// Connexion.
  Future<Result<AuthResult>> login({
    required String email,
    required String password,
  });

  /// Rafraîchit les tokens (via le refresh token stocké).
  Future<Result<AuthTokens>> refresh();

  /// Déconnexion (révoque le refresh token côté serveur + purge locale).
  Future<Result<void>> logout();

  /// Mot de passe oublié.
  Future<Result<void>> forgotPassword(String email);

  /// Réinitialisation avec token.
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Vérification de l'email.
  Future<Result<void>> verifyEmail(String token);

  /// Récupère le profil courant depuis le serveur.
  Future<Result<UserProfile>> getMe();

  /// Lit le profil depuis la base locale (pour démarrage rapide).
  Future<UserProfile?> readLocalProfile();

  /// `true` si des tokens sont présents localement.
  Future<bool> hasTokens();

  /// Purge tous les tokens et données locales.
  Future<void> purgeLocalSession();
}
