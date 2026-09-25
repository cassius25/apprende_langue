import '../../domain/entities/user_profile.dart';

class UserProfileModel {
  const UserProfileModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.emailVerified,
    required this.xp,
    required this.userLevel,
    this.nativeLanguageId,
    this.createdAt,
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final bool emailVerified;
  final String? nativeLanguageId;
  final int xp;
  final int userLevel;
  final String? createdAt;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      role: json['role'] as String? ?? 'USER',
      emailVerified: json['emailVerified'] as bool? ?? false,
      nativeLanguageId: json['nativeLanguageId'] as String?,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      userLevel: (json['userLevel'] as num?)?.toInt() ?? 1,
      createdAt: json['createdAt'] as String?,
    );
  }

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: _parseRole(role),
      emailVerified: emailVerified,
      nativeLanguageId: nativeLanguageId,
      xp: xp,
      userLevel: userLevel,
      createdAt: createdAt != null
          ? DateTime.tryParse(createdAt!)?.toLocal()
          : null,
    );
  }

  static UserRole _parseRole(String r) {
    switch (r) {
      case 'ADMIN':
        return UserRole.admin;
      case 'CONTENT_MANAGER':
        return UserRole.contentManager;
      default:
        return UserRole.user;
    }
  }
}
