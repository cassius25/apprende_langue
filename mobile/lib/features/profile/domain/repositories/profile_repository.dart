import '../../../../core/utils/result.dart';
import '../../../auth/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Result<UserProfile>> getMe();
  Future<Result<UserProfile>> updateMe({
    String? firstName,
    String? lastName,
    String? nativeLanguageId,
  });
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<Result<void>> deleteAccount(String password);
}
