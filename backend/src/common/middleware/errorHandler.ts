import type { ErrorRequestHandler, RequestHandler } from 'express';
import { ZodError } from 'zod';
import { Prisma } from '../../generated/prisma/client';
import { AppError } from '../errors/AppError';
import { isProd } from '../../config/env';
import { logger } from '../../config/logger';

export const notFoundHandler: RequestHandler = (req, res) => {
    res.status(404).json({
        success: false,
        error: {
            code: 'NOT_FOUND',
            message: `Route ${req.method} ${req.originalUrl} not found`,
        },
    });
};

export const errorHandler: ErrorRequestHandler = (err, req, res, _next) => {
    // 1) Zod
    if (err instanceof ZodError) {
        const details = err.flatten();
        logger.warn({ requestId: req.requestId, details }, 'Validation error');
        res.status(422).json({
            success: false,
            error: {
                code: 'VALIDATION_ERROR',
                message: 'Validation failed',
                details,
            },
        });
        return;
    }

    // 2) AppError (nos erreurs opérationnelles)
    if (err instanceof AppError) {
        if (err.statusCode >= 500) {
            logger.error({ requestId: req.requestId, err }, err.message);
        } else {
            logger.warn({ requestId: req.requestId, code: err.code, msg: err.message }, 'Client error');
        }
        res.status(err.statusCode).json({
            success: false,
            error: {
                code: err.code,
                message: err.message,
                ...(err.details !== undefined ? { details: err.details } : {}),
            },
        });
        return;
    }

    // 3) Prisma known errors
    if (err instanceof Prisma.PrismaClientKnownRequestError) {
        const mapped = mapPrismaError(err);
        logger.warn({ requestId: req.requestId, code: err.code, meta: err.meta }, 'Prisma error');
        res.status(mapped.status).json({
            success: false,
            error: { code: mapped.code, message: mapped.message, details: err.meta },
        });
        return;
    }

    if (err instanceof Prisma.PrismaClientValidationError) {
        logger.warn({ requestId: req.requestId }, 'Prisma validation error');
        res.status(400).json({
            success: false,
            error: { code: 'BAD_REQUEST', message: 'Invalid database query' },
        });
        return;
    }

    // 4) Fallback 500
    const anyErr = err as { message?: string; stack?: string };
    logger.error({ requestId: req.requestId, err: anyErr }, 'Unhandled error');
    res.status(500).json({
        success: false,
        error: {
            code: 'INTERNAL_ERROR',
            message: isProd ? 'Internal server error' : anyErr.message ?? 'Internal server error',
            ...(isProd ? {} : { stack: anyErr.stack }),
        },
    });
};

function mapPrismaError(err: Prisma.PrismaClientKnownRequestError): {
    status: number;
    code: string;
    message: string;
} {
    switch (err.code) {
        case 'P2002':
            return { status: 409, code: 'CONFLICT', message: 'Unique constraint violation' };
        case 'P2025':
            return { status: 404, code: 'NOT_FOUND', message: 'Record not found' };
        case 'P2003':
            return { status: 409, code: 'CONFLICT', message: 'Foreign key constraint violation' };
        case 'P2000':
            return { status: 400, code: 'BAD_REQUEST', message: 'Value too long for the column type' };
        default:
            return { status: 500, code: 'INTERNAL_ERROR', message: 'Database error' };
    }
}