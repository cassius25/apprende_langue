import '../../../../core/utils/result.dart';
import '../../../auth/domain/entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  GetProfileUseCase(this._r);
  final ProfileRepository _r;
  Future<Result<UserProfile>> call() => _r.getMe();
}

class UpdateProfileUseCase {
  UpdateProfileUseCase(this._r);
  final ProfileRepository _r;
  Future<Result<UserProfile>> call({
    String? firstName,
    String? lastName,
    String? nativeLanguageId,
  }) => _r.updateMe(
    firstName: firstName,
    lastName: lastName,
    nativeLanguageId: nativeLanguageId,
  );
}

class ChangePasswordUseCase {
  ChangePasswordUseCase(this._r);
  final ProfileRepository _r;
  Future<Result<void>> call({
    required String currentPassword,
    required String newPassword,
  }) => _r.changePassword(
    currentPassword: currentPassword,
    newPassword: newPassword,
  );
}

class DeleteAccountUseCase {
  DeleteAccountUseCase(this._r);
  final ProfileRepository _r;
  Future<Result<void>> call(String password) => _r.deleteAccount(password);
}
