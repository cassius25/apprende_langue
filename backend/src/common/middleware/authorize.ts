import type { NextFunction, Request, RequestHandler, Response } from 'express';
import type { Role } from '../../generated/prisma/client';
import { ForbiddenError, UnauthorizedError } from '../errors/HttpErrors';

/** Restreint l'accès aux rôles fournis. Doit être utilisé après `authenticate`. */
export const authorize =
    (...allowedRoles: Role[]): RequestHandler =>
        (req: Request, _res: Response, next: NextFunction) => {
            if (!req.user) return next(new UnauthorizedError());
            if (allowedRoles.length === 0) return next();
            if (!allowedRoles.includes(req.user.role)) {
                return next(new ForbiddenError('Insufficient permissions'));
            }
            next();
        };