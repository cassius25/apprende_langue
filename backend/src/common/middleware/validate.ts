import type { NextFunction, Request, Response } from 'express';
import type { ZodTypeAny } from 'zod';

interface Schemas {
    body?: ZodTypeAny;
    query?: ZodTypeAny;
    params?: ZodTypeAny;
}

/**
 * Valide req.body / req.query / req.params via Zod.
 * Les valeurs validées et transformées remplacent celles d'origine.
 */
export const validate =
    (schemas: Schemas) => (req: Request, _res: Response, next: NextFunction) => {
        try {
            if (schemas.params) req.params = schemas.params.parse(req.params) as typeof req.params;
            if (schemas.query) {
                // req.query est en lecture seule en Express 5 ; on mute via assign
                const parsed = schemas.query.parse(req.query);
                Object.assign(req.query, parsed);
            }
            if (schemas.body) req.body = schemas.body.parse(req.body);
            next();
        } catch (err) {
            next(err);
        }
    };