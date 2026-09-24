import type { Express } from 'express';
import swaggerUi from 'swagger-ui-express';
import { env } from './env';

// Spec de base — sera enrichie module par module.
// En production, on peut basculer sur un fichier openapi.yaml (src/docs/openapi.yaml)
// servi directement via swagger-ui-express.
const spec = {
    openapi: '3.0.3',
    info: {
        title: 'LangApp API',
        version: '1.0.0',
        description: 'API REST pour l’application mobile d’apprentissage des langues.',
    },
    servers: [
        { url: `http://localhost:${env.PORT}${env.API_PREFIX}`, description: 'Local' },
    ],
    components: {
        securitySchemes: {
            bearerAuth: { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' },
        },
    },
    security: [{ bearerAuth: [] }],
    tags: [
        { name: 'Auth' },
        { name: 'Users' },
        { name: 'Languages' },
        { name: 'Courses' },
        { name: 'Lessons' },
        { name: 'Vocabulary' },
        { name: 'Exercises' },
        { name: 'Progress' },
        { name: 'Reviews' },
        { name: 'Streaks' },
        { name: 'Statistics' },
        { name: 'Sync' },
    ],
    paths: {
        '/health': {
            get: {
                tags: ['System'],
                summary: 'Health check',
                responses: { '200': { description: 'OK' } },
            },
        },
    },
} as const;

export function setupSwagger(app: Express): void {
    app.use('/docs', swaggerUi.serve, swaggerUi.setup(spec, { explorer: true }));
    app.get('/docs.json', (_req, res) => res.json(spec));
}