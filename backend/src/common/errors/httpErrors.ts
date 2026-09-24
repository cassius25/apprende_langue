import { AppError } from './AppError';

export class BadRequestError extends AppError {
    constructor(message = 'Bad request', details?: unknown) {
        super(message, 400, { code: 'BAD_REQUEST', details });
    }
}

export class UnauthorizedError extends AppError {
    constructor(message = 'Unauthorized', details?: unknown) {
        super(message, 401, { code: 'UNAUTHORIZED', details });
    }
}

export class ForbiddenError extends AppError {
    constructor(message = 'Forbidden', details?: unknown) {
        super(message, 403, { code: 'FORBIDDEN', details });
    }
}

export class NotFoundError extends AppError {
    constructor(message = 'Resource not found', details?: unknown) {
        super(message, 404, { code: 'NOT_FOUND', details });
    }
}

export class ConflictError extends AppError {
    constructor(message = 'Conflict', details?: unknown) {
        super(message, 409, { code: 'CONFLICT', details });
    }
}

export class ValidationError extends AppError {
    constructor(message = 'Validation failed', details?: unknown) {
        super(message, 422, { code: 'VALIDATION_ERROR', details });
    }
}

export class RateLimitedError extends AppError {
    constructor(message = 'Too many requests', details?: unknown) {
        super(message, 429, { code: 'RATE_LIMITED', details });
    }
}

export class ServiceUnavailableError extends AppError {
    constructor(message = 'Service unavailable', details?: unknown) {
        super(message, 503, { code: 'SERVICE_UNAVAILABLE', details });
    }
}