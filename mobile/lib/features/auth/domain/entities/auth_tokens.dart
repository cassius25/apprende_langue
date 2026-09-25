import 'package:equatable/equatable.dart';

class AuthTokens extends Equatable {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresIn,
    this.refreshTokenExpiresAt,
  });

  final String accessToken;
  final String refreshToken;
  final int accessTokenExpiresIn; // secondes
  final String? refreshTokenExpiresAt; // ISO 8601

  @override
  List<Object?> get props => [
    accessToken,
    refreshToken,
    accessTokenExpiresIn,
    refreshTokenExpiresAt,
  ];
}
