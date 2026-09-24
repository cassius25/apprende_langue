import { randomUUID } from 'node:crypto';
import type { NextFunction, Request, Response } from 'express';

const HEADER = 'x-request-id';

export function requestId(req: Request, res: Response, next: NextFunction): void {
    const incoming = req.headers[HEADER];
    const id = typeof incoming === 'string' && incoming.length > 0 ? incoming : randomUUID();

    req.requestId = id;
    res.setHeader(HEADER, id);
    next();
}