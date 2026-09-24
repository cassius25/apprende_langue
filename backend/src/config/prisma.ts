// src/prismaClient.ts
import 'dotenv/config';
import pino from 'pino';
import { PrismaClient } from '../generated/prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import pg from 'pg';

const logger = pino({ level: 'info' });

const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);

export const prisma = new PrismaClient({
    adapter,
    log: [
        { emit: 'event', level: 'query' },
        { emit: 'event', level: 'warn' },
        { emit: 'event', level: 'error' },
    ],
});

prisma.$on('query', (e: { query: any; params: any; duration: any; }) => {
    logger.debug({ query: e.query, params: e.params, ms: e.duration }, 'prisma query');
});

prisma.$on('warn', (e: { message: any; }) => logger.warn({ msg: e.message }, 'prisma warn'));
prisma.$on('error', (e: { message: any; }) => logger.error({ msg: e.message }, 'prisma error'));