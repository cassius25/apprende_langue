import 'package:langapp/core/utils/result.dart';

import '../entities/auth_tokens.dart';
import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

/// Regroupe tous les cas d'usage auth dans un seul fichier — chacun est
/// un wrapper fin autour du repository, ce qui facilite les tests isolés.

class RegisterUseCase {
  RegisterUseCase(this._repo);
  final AuthRepository _repo;
  Future<Result<AuthResult>> call(RegisterParams params) =>
      _repo.register(params);
}

class LoginUseCase {
  LoginUseCase(this._repo);
  final AuthRepository _repo;
  Future<Result<AuthResult>> call({
    required String email,
    required String password,
  }) => _repo.login(email: email, password: password);
}

class RefreshUseCase {
  RefreshUseCase(this._repo);
  final AuthRepository _repo;
  Future<Result<AuthTokens>> call() => _repo.refresh();
}

class LogoutUseCase {
  LogoutUseCase(this._repo);
  final AuthRepository _repo;
  Future<Result<void>> call() => _repo.logout();
}

class ForgotPasswordUseCase {
  ForgotPasswordUseCase(this._repo);
  final AuthRepository _repo;
  Future<Result<void>> call(String email) => _repo.forgotPassword(email);
}

class ResetPasswordUseCase {
  ResetPasswordUseCase(this._repo);
  final AuthRepository _repo;
  Future<Result<void>> call({
    required String token,
    required String newPassword,
  }) => _repo.resetPassword(token: token, newPassword: newPassword);
}

class VerifyEmailUseCase {
  VerifyEmailUseCase(this._repo);
  final AuthRepository _repo;
  Future<Result<void>> call(String token) => _repo.verifyEmail(token);
}

class GetMeUseCase {
  GetMeUseCase(this._repo);
  final AuthRepository _repo;
  Future<Result<UserProfile>> call() => _repo.getMe();
}
