import type { Role } from '../../generated/prisma/client';

export interface PublicUser {
    id: string;
    email: string;
    firstName: string;
    lastName: string;
    role: Role;
    emailVerified: boolean;
    nativeLanguageId: string | null;
    xp: number;
    userLevel: number;
    createdAt: string;
}

export interface AuthTokens {
    accessToken: string;
    refreshToken: string;
    accessTokenExpiresIn: number; // secondes
    refreshTokenExpiresAt: string; // ISO
}

export interface AuthResponse {
    user: PublicUser;
    tokens: AuthTokens;
}