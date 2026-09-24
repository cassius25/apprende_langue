import { NotFoundError } from '../../common/errors/HttpErrors';
import { buildPaginationMeta, normalizePagination } from '../../common/utils/pagination';
import { prisma } from '../../config/prisma';
import { progressRepository } from './progress.repository';
import { reviewRepository } from '../reviews/review.repository';
import type {
    GlobalProgressDto,
    LanguageProgressDto,
    LessonProgressItemDto,
} from './progress.dto';
import type { LessonsProgressQuery } from './progress.schemas';

const XP_PER_LEVEL = 200;

function percent(part: number, total: number): number {
    if (total === 0) return 0;
    return Math.round((part / total) * 1000) / 10; // 1 décimale
}

async function buildLanguageProgress(
    userId: string,
    userLanguage: {
        language: { id: string; code: string; name: string; flagEmoji: string | null };
        levelId: string | null;
        isActive: boolean;
        startedAt: Date;
    },
): Promise<LanguageProgressDto> {
    const languageId = userLanguage.language.id;

    // Niveaux + progression
    const rawLevels = await progressRepository.levelProgress(userId, languageId);
    const levels = rawLevels.map((l) => ({
        id: l.id,
        code: l.code,
        name: l.name,
        order: l.order,
        lessonsCompleted: l.lessonsCompleted,
        lessonsTotal: l.lessonsTotal,
        progressPercent: percent(l.lessonsCompleted, l.lessonsTotal),
    }));

    const lessonsCompleted = levels.reduce((acc, l) => acc + l.lessonsCompleted, 0);
    const lessonsTotal = levels.reduce((acc, l) => acc + l.lessonsTotal, 0);
    const progressPercent = percent(lessonsCompleted, lessonsTotal);

    const currentLevel = userLanguage.levelId
        ? levels.find((l) => l.id === userLanguage.levelId) ?? null
        : levels.find((l) => l.lessonsCompleted > 0 && l.progressPercent < 100) ?? levels[0] ?? null;

    const vocab = await progressRepository.vocabularyStats(userId, languageId);

    return {
        language: userLanguage.language,
        currentLevel: currentLevel
            ? { id: currentLevel.id, code: currentLevel.code, name: currentLevel.name }
            : null,
        progressPercent,
        isActive: userLanguage.isActive,
        startedAt: userLanguage.startedAt.toISOString(),
        levels,
        lessonsCompleted,
        lessonsTotal,
        vocabularyLearned: vocab.total,
        vocabularyMastered: vocab.mastered,
    };
}

export const progressService = {
    // ────────────────────────────────────────────────────────
    // Vue globale
    // ────────────────────────────────────────────────────────
    async getGlobal(userId: string): Promise<GlobalProgressDto> {
        const [user, userLanguages, lessonsCompleted, lessonsTotal, dueToday] = await Promise.all([
            progressRepository.getUserXp(userId),
            progressRepository.findUserLanguages(userId),
            progressRepository.countCompletedLessons(userId),
            progressRepository.countPublishedLessons(),
            reviewRepository.countDue(userId),
        ]);

        if (!user) throw new NotFoundError('User not found');

        const streakRow = await prisma.streak.findUnique({ where: { userId } });

        const languages: LanguageProgressDto[] = [];
        for (const ul of userLanguages) {
            languages.push(await buildLanguageProgress(userId, ul));
        }

        const totalVocab = languages.reduce((acc, l) => acc + l.vocabularyLearned, 0);
        const totalMastered = languages.reduce((acc, l) => acc + l.vocabularyMastered, 0);

        const xpInCurrentLevel = user.xp % XP_PER_LEVEL;
        const xpToNextLevel = XP_PER_LEVEL - xpInCurrentLevel;

        return {
            totalXp: user.xp,
            userLevel: user.userLevel,
            xpInCurrentLevel,
            xpToNextLevel,
            lessonsCompleted,
            lessonsTotal,
            vocabularyTotal: totalVocab,
            vocabularyMastered: totalMastered,
            languages,
            currentStreak: streakRow?.currentStreak ?? 0,
            longestStreak: streakRow?.longestStreak ?? 0,
            dueToday,
        };
    },

    // ────────────────────────────────────────────────────────
    // Progression par langue
    // ────────────────────────────────────────────────────────
    async getForLanguage(userId: string, languageId: string): Promise<LanguageProgressDto> {
        const ul = await prisma.userLanguage.findUnique({
            where: { userId_languageId: { userId, languageId } },
            include: {
                language: { select: { id: true, code: true, name: true, flagEmoji: true } },
            },
        });
        if (!ul) throw new NotFoundError('Language not enrolled');

        return buildLanguageProgress(userId, ul);
    },

    // ────────────────────────────────────────────────────────
    // Liste des leçons avec progression
    // ────────────────────────────────────────────────────────
    async listLessons(userId: string, query: LessonsProgressQuery) {
        const { page, limit, skip, take } = normalizePagination(query);
        const { lessons, total } = await progressRepository.listLessonsWithProgress(
            userId,
            { languageId: query.languageId, status: query.status },
            { skip, take },
        );

        const data: LessonProgressItemDto[] = lessons.map((l) => {
            const p = l.userProgress[0];
            return {
                lessonId: l.id,
                title: l.title,
                moduleTitle: l.module.title,
                courseTitle: l.module.course.title,
                language: {
                    id: l.module.course.language.id,
                    code: l.module.course.language.code,
                    name: l.module.course.language.name,
                    flagEmoji: l.module.course.language.flagEmoji,
                },
                level: {
                    code: l.module.course.level.code,
                    name: l.module.course.level.name,
                },
                status: p ? (p.status as LessonProgressItemDto['status']) : 'NOT_STARTED',
                score: p?.score ?? 0,
                timeSpentSec: p?.timeSpentSec ?? 0,
                completedAt: p?.completedAt ? p.completedAt.toISOString() : null,
            };
        });

        return { data, meta: buildPaginationMeta(page, limit, total) };
    },
};