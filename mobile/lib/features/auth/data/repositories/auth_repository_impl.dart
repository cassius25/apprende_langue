import 'package:dartz/dartz.dart';
import 'package:langapp/core/errors/app_failure.dart';
import 'package:langapp/core/utils/result.dart';

import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this._remote, required this._local});

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<Result<AuthResult>> register(RegisterParams params) async {
    final result = await _remote.register(params);
    if (result.isLeft()) return Left(result.failureOrNull!);
    final auth = result.valueOrNull!;
    await _persistAuth(auth);
    return Right(auth);
  }

  @override
  Future<Result<AuthResult>> login({
    required String email,
    required String password,
  }) async {
    final result = await _remote.login(email: email, password: password);
    if (result.isLeft()) return Left(result.failureOrNull!);
    final auth = result.valueOrNull!;
    await _persistAuth(auth);
    return Right(auth);
  }

  @override
  Future<Result<AuthTokens>> refresh() async {
    final refreshToken = await _local.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return const Left(UnauthorizedFailure('Session absente'));
    }
    final result = await _remote.refresh(refreshToken);
    if (result.isLeft()) return Left(result.failureOrNull!);
    final tokens = result.valueOrNull!;
    await _local.saveTokens(tokens);
    return Right(tokens);
  }

  @override
  Future<Result<void>> logout() async {
    final refreshToken = await _local.readRefreshToken();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _remote.logout(refreshToken);
    }
    await _local.purgeSession();
    return const Right(null);
  }

  @override
  Future<Result<void>> forgotPassword(String email) =>
      _remote.forgotPassword(email);

  @override
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  }) => _remote.resetPassword(token: token, newPassword: newPassword);

  @override
  Future<Result<void>> verifyEmail(String token) => _remote.verifyEmail(token);

  @override
  Future<Result<UserProfile>> getMe() async {
    final result = await _remote.getMe();
    if (result.isLeft()) return Left(result.failureOrNull!);
    final user = result.valueOrNull!;
    await _local.saveProfile(user);
    return Right(user);
  }

  @override
  Future<UserProfile?> readLocalProfile() => _local.readProfile();

  @override
  Future<bool> hasTokens() => _local.hasTokens();

  @override
  Future<void> purgeLocalSession() => _local.purgeSession();

  Future<void> _persistAuth(AuthResult auth) async {
    await _local.saveTokens(auth.tokens);
    await _local.saveProfile(auth.user);
  }
}
