import http from 'node:http';
import { createApp } from './app';
import { env } from './config/env';
import { logger } from './config/logger';
import { prisma } from './config/prisma';

async function bootstrap(): Promise<void> {
    const app = createApp();
    const server = http.createServer(app);

    // Connexion DB
    try {
        await prisma.$connect();
        logger.info('✅ Connected to PostgreSQL');
    } catch (err) {
        logger.fatal({ err }, '❌ Failed to connect to PostgreSQL');
        process.exit(1);
    }

    server.listen(env.PORT, () => {
        logger.info(`🚀 API listening on http://localhost:${env.PORT} (${env.NODE_ENV})`);
    });

    // ─── Graceful shutdown ──────────────────────────────────
    const shutdown = async (signal: string): Promise<void> => {
        logger.info({ signal }, 'Shutting down...');
        server.close(async (err) => {
            if (err) logger.error({ err }, 'Error while closing HTTP server');
            try {
                await prisma.$disconnect();
                logger.info('Prisma disconnected. Bye 👋');
                process.exit(err ? 1 : 0);
            } catch (e) {
                logger.error({ err: e }, 'Error while disconnecting Prisma');
                process.exit(1);
            }
        });

        // Filet de sécurité si le close ne finit pas
        setTimeout(() => {
            logger.error('Forced shutdown after timeout');
            process.exit(1);
        }, 10_000).unref();
    };

    process.on('SIGINT', () => void shutdown('SIGINT'));
    process.on('SIGTERM', () => void shutdown('SIGTERM'));
    process.on('unhandledRejection', (reason) => logger.error({ reason }, 'unhandledRejection'));
    process.on('uncaughtException', (err) => {
        logger.fatal({ err }, 'uncaughtException');
        void shutdown('uncaughtException');
    });
}

void bootstrap();