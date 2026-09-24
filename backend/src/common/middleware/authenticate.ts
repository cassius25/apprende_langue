import type { NextFunction, Request, Response } from 'express';
import { prisma } from '../../config/prisma';
import { UnauthorizedError } from '../errors/HttpErrors';
import { extractBearerToken, verifyAccessToken } from '../utils/jwt';

/**
 * Vérifie le JWT d'accès, puis confirme que l'utilisateur existe toujours
 * (et n'a pas été soft-deleted). Positionne req.user.
 */
export async function authenticate(req: Request, _res: Response, next: NextFunction): Promise<void> {
    try {
        const token = extractBearerToken(req.headers.authorization);
        if (!token) throw new UnauthorizedError('Missing bearer token');

        const payload = verifyAccessToken(token);

        const user = await prisma.user.findUnique({
            where: { id: payload.sub },
            select: { id: true, email: true, role: true, emailVerified: true, deletedAt: true },
        });

        if (!user || user.deletedAt) throw new UnauthorizedError('User no longer exists');

        req.user = {
            id: user.id,
            email: user.email,
            role: user.role,
            emailVerified: user.emailVerified,
        };

        next();
    } catch (err) {
        next(err);
    }
}

/** Bloque si l'email n'est pas vérifié (à utiliser sur les routes sensibles). */
export function requireVerifiedEmail(req: Request, _res: Response, next: NextFunction): void {
    if (!req.user) return next(new UnauthorizedError());
    if (!req.user.emailVerified) {
        return next(new UnauthorizedError('Email not verified'));
    }
    next();
}