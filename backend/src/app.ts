import express, { type Express } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import pinoHttp from 'pino-http';
import { env, isDev } from './config/env';
import { logger } from './config/logger';
import { setupSwagger } from './config/swagger';
import { requestId } from './common/middleware/requestId';
import { errorHandler, notFoundHandler } from './common/middleware/errorHandler';
import { globalRateLimiter } from './common/middleware/rateLimit';
import routes from './routes';

export function createApp(): Express {
    const app = express();

    // ─── Sécurité & parsing ─────────────────────────────────
    app.disable('x-powered-by');
    app.set('trust proxy', 1);

    app.use(helmet());
    app.use(
        cors({
            origin: env.CORS_ORIGINS === '*' ? true : env.CORS_ORIGINS.split(',').map((s: string) => s.trim()),
            credentials: true,
        }),
    );
    app.use(express.json({ limit: '1mb' }));
    app.use(express.urlencoded({ extended: true }));

    // ─── Observabilité ──────────────────────────────────────
    app.use(requestId);
    app.use(
        pinoHttp({
            logger,
            genReqId: (req: { requestId?: string; }) => (req as { requestId?: string }).requestId ?? '',
            customLogLevel: (_req: any, res: { statusCode: number; }, err: any) => {
                if (err || res.statusCode >= 500) return 'error';
                if (res.statusCode >= 400) return 'warn';
                return 'info';
            },
            serializers: {
                req: (req: { method: any; url: any; }) => ({ method: req.method, url: req.url }),
                res: (res: { statusCode: any; }) => ({ statusCode: res.statusCode }),
            },
        }),
    );

    // ─── Rate limit global ──────────────────────────────────
    app.use(globalRateLimiter);

    // ─── Docs ───────────────────────────────────────────────
    setupSwagger(app);

    // ─── Routes ─────────────────────────────────────────────
    app.use(env.API_PREFIX, routes);

    // ─── 404 + erreurs ──────────────────────────────────────
    app.use(notFoundHandler);
    app.use(errorHandler);

    if (isDev) {
        logger.info(`Swagger UI  →  http://localhost:${env.PORT}/docs`);
        logger.info(`API base    →  http://localhost:${env.PORT}${env.API_PREFIX}`);
    }

    return app;
}