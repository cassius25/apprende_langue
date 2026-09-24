import 'dotenv/config';
import { z } from 'zod';

const envSchema = z.object({
    NODE_ENV: z.enum(['development', 'staging', 'production', 'test']).default('development'),
    PORT: z.coerce.number().int().positive().default(4000),
    API_PREFIX: z.string().default('/api/v1'),

    DATABASE_URL: z.string().url(),

    JWT_ACCESS_SECRET: z.string().min(32, 'JWT_ACCESS_SECRET must be at least 32 chars'),
    JWT_ACCESS_EXPIRES_IN: z.string().default('15m'),
    JWT_REFRESH_EXPIRES_IN_DAYS: z.coerce.number().int().positive().default(30),

    ARGON_MEMORY_COST: z.coerce.number().int().positive().default(19456),
    ARGON_TIME_COST: z.coerce.number().int().positive().default(2),
    ARGON_PARALLELISM: z.coerce.number().int().positive().default(1),

    CORS_ORIGINS: z.string().default('*'),

    RATE_LIMIT_WINDOW_MS: z.coerce.number().int().positive().default(900_000),
    RATE_LIMIT_MAX: z.coerce.number().int().positive().default(200),

    LOG_LEVEL: z.enum(['fatal', 'error', 'warn', 'info', 'debug', 'trace', 'silent']).default('info'),
});

const parsed = envSchema.safeParse(process.env);

if (!parsed.success) {
    // eslint-disable-next-line no-console
    console.error('❌ Invalid environment variables:\n', parsed.error.flatten().fieldErrors);
    process.exit(1);
}

export const env = parsed.data;

export const isProd = env.NODE_ENV === 'production';
export const isDev = env.NODE_ENV === 'development';
export const isTest = env.NODE_ENV === 'test';