import type { RefreshToken, User } from '../../generated/prisma/client';
import { env } from '../../config/env';
import { AppError } from '../../common/errors/AppError';
import { UnauthorizedError } from '../../common/errors/HttpErrors';
import { addDays, generateOpaqueToken, sha256 } from '../../common/utils/crypto';
import { signAccessToken } from '../../common/utils/jwt';
import { authRepository } from './auth.repository';
import type { AuthTokens } from './auth.dto';
import type { Request } from 'express';

const REFRESH_BYTES = 48;

export interface IssuedRefreshToken {
    raw: string;
    record: RefreshToken;
}

export const tokenService = {
    buildAccessToken(user: User): { token: string; expiresIn: number } {
        const token = signAccessToken({
            sub: user.id,
            email: user.email,
            role: user.role,
            emailVerified: user.emailVerified,
        });
        // 15 minutes
        const expiresIn = 15 * 60;
        return { token, expiresIn };
    },

    async issueRefreshToken(userId: string, req: Request): Promise<IssuedRefreshToken> {
        const raw = generateOpaqueToken(REFRESH_BYTES);
        const tokenHash = sha256(raw);
        const expiresAt = addDays(env.JWT_REFRESH_EXPIRES_IN_DAYS);

        const record = await authRepository.createRefreshToken({
            userId,
            tokenHash,
            expiresAt,
            userAgent: typeof req.headers['user-agent'] === 'string' ? req.headers['user-agent'] : null,
            ipAddress: req.ip ?? null,
        });

        return { raw, record };
    },

    async buildAuthTokens(user: User, req: Request): Promise<AuthTokens> {
        const access = this.buildAccessToken(user);
        const refresh = await this.issueRefreshToken(user.id, req);
        return {
            accessToken: access.token,
            accessTokenExpiresIn: access.expiresIn,
            refreshToken: refresh.raw,
            refreshTokenExpiresAt: refresh.record.expiresAt.toISOString(),
        };
    },

    /**
     * Vérifie un refresh token.
     * - Révoqué  → révoque toutes les sessions de l'utilisateur + UnauthorizedError (rotation reuse detection)
     * - Expiré   → UnauthorizedError
     * - Inconnu  → UnauthorizedError
     */
    async verifyRefreshToken(raw: string): Promise<RefreshToken> {
        const tokenHash = sha256(raw);
        const record = await authRepository.findRefreshTokenByHash(tokenHash);
        if (!record) throw new UnauthorizedError('Invalid refresh token');

        if (record.revokedAt) {
            // Réutilisation détectée → on coupe toutes les sessions
            await authRepository.revokeAllUserRefreshTokens(record.userId);
            throw new AppError('Refresh token reuse detected — all sessions revoked', 401, {
                code: 'UNAUTHORIZED',
            });
        }

        if (record.expiresAt.getTime() <= Date.now()) {
            throw new UnauthorizedError('Refresh token expired');
        }

        return record;
    },
};