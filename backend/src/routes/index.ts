import { Router } from 'express';
import { prisma } from '../config/prisma';
import authRoutes from '../modules/auth/auth.routes';
import courseRoutes from '@/modules/courses/course.routes';
import exerciseRoutes from '@/modules/exercises/exercise.routes';
import languageRoutes from '@/modules/languages/language.routes';
import lessonRoutes from '@/modules/lessons/lesson.routes';
import progressRoutes from '@/modules/progress/progress.routes';
import reviewRoutes from '@/modules/reviews/review.routes';
import streakRoutes from '@/modules/streaks/streak.routes';
import syncRoutes from '@/modules/synchronization/sync.routes';
import userRoutes from '@/modules/users/user.routes';
import vocabularyRoutes from '@/modules/vocabulary/vocabulary.routes';
import statsRoutes from '@/modules/statistics/statistics.routes';

const router = Router();

// ─── Health ─────────────────────────────────────────────────
router.get('/health', async (_req, res) => {
    let dbOk = true;
    try {
        await prisma.$queryRaw`SELECT 1`;
    } catch {
        dbOk = false;
    }

    res.status(dbOk ? 200 : 503).json({
        success: dbOk,
        status: dbOk ? 'ok' : 'degraded',
        uptime: process.uptime(),
        timestamp: new Date().toISOString(),
        db: dbOk ? 'up' : 'down',
    });
});

// ─── Modules ────────────────────────────────────────────────
router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/languages', languageRoutes);
router.use('/courses', courseRoutes);
router.use('/lessons', lessonRoutes);
router.use('/vocabulary', vocabularyRoutes);
router.use('/exercises', exerciseRoutes);
router.use('/progress', progressRoutes);
router.use('/reviews', reviewRoutes);
router.use('/streak', streakRoutes);
router.use('/statistics', statsRoutes);
router.use('/sync', syncRoutes);

export default router;