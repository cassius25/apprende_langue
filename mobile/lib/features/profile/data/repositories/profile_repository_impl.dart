import '../../../../core/utils/result.dart';
import '../../../auth/domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remote);
  final ProfileRemoteDataSource _remote;

  @override
  Future<Result<UserProfile>> getMe() => _remote.getMe();

  @override
  Future<Result<UserProfile>> updateMe({
    String? firstName,
    String? lastName,
    String? nativeLanguageId,
  }) => _remote.updateMe(
    firstName: firstName,
    lastName: lastName,
    nativeLanguageId: nativeLanguageId,
  );

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => _remote.changePassword(
    currentPassword: currentPassword,
    newPassword: newPassword,
  );

  @override
  Future<Result<void>> deleteAccount(String password) =>
      _remote.deleteAccount(password);
}
