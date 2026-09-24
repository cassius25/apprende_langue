import pino from 'pino';
import { env, isDev, isTest } from './env';

export const logger = pino({
    level: env.LOG_LEVEL,
    enabled: !isTest,
    base: { service: 'langapp-api' },
    timestamp: pino.stdTimeFunctions.isoTime,
    redact: {
        paths: [
            'req.headers.authorization',
            'req.headers.cookie',
            'password',
            'passwordHash',
            'token',
            'refreshToken',
            'accessToken',
            '*.password',
            '*.passwordHash',
            '*.token',
        ],
        remove: true,
    },
    transport: isDev
        ? {
            target: 'pino-pretty',
            options: { colorize: true, translateTime: 'SYS:HH:MM:ss.l', ignore: 'pid,hostname' },
        }
        : undefined,
});

export type Logger = typeof logger;