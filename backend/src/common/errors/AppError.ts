export type ErrorCode =
    | 'BAD_REQUEST'
    | 'UNAUTHORIZED'
    | 'FORBIDDEN'
    | 'NOT_FOUND'
    | 'CONFLICT'
    | 'VALIDATION_ERROR'
    | 'RATE_LIMITED'
    | 'INTERNAL_ERROR'
    | 'SERVICE_UNAVAILABLE';

export interface AppErrorOptions {
    code?: ErrorCode;
    details?: unknown;
    cause?: unknown;
    isOperational?: boolean;
}

export class AppError extends Error {
    public readonly statusCode: number;
    public readonly code: ErrorCode;
    public readonly details?: unknown;
    public readonly isOperational: boolean;

    constructor(message: string, statusCode = 500, options: AppErrorOptions = {}) {
        super(message);
        this.name = this.constructor.name;
        this.statusCode = statusCode;
        this.code = options.code ?? 'INTERNAL_ERROR';
        this.details = options.details;
        this.isOperational = options.isOperational ?? true;

        if (options.cause) (this as { cause?: unknown }).cause = options.cause;
        Error.captureStackTrace?.(this, this.constructor);
    }
}