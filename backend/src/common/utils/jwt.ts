import jwt from 'jsonwebtoken';
import { env } from '../../config/env';
import { UnauthorizedError } from '../errors/HttpErrors';
import type { Role } from '../../generated/prisma/client';

export interface AccessTokenPayload {
    sub: string; // userId
    email: string;
    role: Role;
    emailVerified: boolean;
}

const ISSUER = 'langapp';
const AUDIENCE = 'langapp-mobile';

export function signAccessToken(payload: AccessTokenPayload): string {
    return jwt.sign(payload, env.JWT_ACCESS_SECRET, {
        expiresIn: env.JWT_ACCESS_EXPIRES_IN as jwt.SignOptions['expiresIn'],
        issuer: ISSUER,
        audience: AUDIENCE,
    });
}

export function verifyAccessToken(token: string): AccessTokenPayload {
    try {
        const decoded = jwt.verify(token, env.JWT_ACCESS_SECRET, {
            issuer: ISSUER,
            audience: AUDIENCE,
        });
        if (typeof decoded === 'string') {
            throw new UnauthorizedError('Invalid access token');
        }
        return decoded as AccessTokenPayload;
    } catch (err) {
        if (err instanceof jwt.TokenExpiredError) {
            throw new UnauthorizedError('Access token expired');
        }
        throw new UnauthorizedError('Invalid access token');
    }
}

export function extractBearerToken(header: string | undefined): string | null {
    if (!header) return null;
    const [scheme, token] = header.split(' ');
    if (scheme?.toLowerCase() !== 'bearer' || !token) return null;
    return token;
}