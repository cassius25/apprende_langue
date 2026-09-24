import rateLimit from 'express-rate-limit';
import { env, isTest } from '../../config/env';

const baseOptions = {
    windowMs: env.RATE_LIMIT_WINDOW_MS,
    standardHeaders: true,
    legacyHeaders: false,
    skip: () => isTest,
    message: {
        success: false,
        error: { code: 'RATE_LIMITED', message: 'Too many requests, please try again later.' },
    },
};

export const globalRateLimiter = rateLimit({
    ...baseOptions,
    max: env.RATE_LIMIT_MAX,
});

/** Rate limit strict pour login / register / refresh / forgot-password */
export const authRateLimiter = rateLimit({
    ...baseOptions,
    windowMs: 15 * 60 * 1000,
    max: 20,
});

/** Rate limit pour endpoints de sync (potentiellement lourds) */
export const syncRateLimiter = rateLimit({
    ...baseOptions,
    windowMs: 60 * 1000,
    max: 60,
});