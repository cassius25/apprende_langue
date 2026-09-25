import 'package:equatable/equatable.dart';

enum UserRole { user, admin, contentManager }

class UserProfile extends Equatable {
  const UserProfile({
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
  final UserRole role;
  final bool emailVerified;
  final String? nativeLanguageId;
  final int xp;
  final int userLevel;
  final DateTime? createdAt;

  String get displayName => '$firstName $lastName'.trim();

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    role,
    emailVerified,
    nativeLanguageId,
    xp,
    userLevel,
    createdAt,
  ];
}
