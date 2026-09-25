import '../../domain/entities/auth_tokens.dart';

class AuthTokensModel {
  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresIn,
    this.refreshTokenExpiresAt,
  });

  final String accessToken;
  final String refreshToken;
  final int accessTokenExpiresIn;
  final String? refreshTokenExpiresAt;

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      accessTokenExpiresIn:
          (json['accessTokenExpiresIn'] as num?)?.toInt() ?? 900,
      refreshTokenExpiresAt: json['refreshTokenExpiresAt'] as String?,
    );
  }

  AuthTokens toEntity() => AuthTokens(
    accessToken: accessToken,
    refreshToken: refreshToken,
    accessTokenExpiresIn: accessTokenExpiresIn,
    refreshTokenExpiresAt: refreshTokenExpiresAt,
  );
}
