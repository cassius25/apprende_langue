import { prisma } from '../../config/prisma';

export const statisticsRepository = {
    aggregateActivity(userId: string, since: Date) {
        return prisma.dailyActivity.aggregate({
            where: { userId, date: { gte: since } },
            _sum: {
                minutesLearned: true,
                xpEarned: true,
                wordsLearned: true,
                wordsReviewed: true,
                exercisesDone: true,
                exercisesCorrect: true,
            },
        });
    },

    countUserVocabularyByState(userId: string, state: 'NEW' | 'LEARNING' | 'REVIEW' | 'MASTERED') {
        return prisma.userVocabulary.count({
            where: { userId, state, deletedAt: null },
        });
    },

    countUserVocabularyTotal(userId: string) {
        return prisma.userVocabulary.count({ where: { userId, deletedAt: null } });
    },

    countLessonsCompleted(userId: string, languageId?: string) {
        return prisma.userProgress.count({
            where: {
                userId,
                status: 'COMPLETED',
                ...(languageId ? { lesson: { module: { course: { languageId } } } } : {}),
            },
        });
    },

    countLessonsTotal(languageId?: string) {
        return prisma.lesson.count({
            where: {
                isPublished: true,
                deletedAt: null,
                ...(languageId ? { module: { course: { languageId, deletedAt: null } } } : {}),
            },
        });
    },

    findActivityRange(userId: string, from: Date, to: Date) {
        return prisma.dailyActivity.findMany({
            where: { userId, date: { gte: from, lte: to } },
            orderBy: { date: 'asc' },
        });
    },

    /** Exercices complétés pour une langue donnée, groupés par type. */
    async exerciseTypeDistribution(userId: string, languageId?: string) {
        // On ne stocke pas les tentatives d'exercices par type — on utilise
        // une approximation basée sur les exercices publiés et la réussite des leçons.
        const lessonsCompleted = await prisma.userProgress.findMany({
            where: {
                userId,
                status: 'COMPLETED',
                ...(languageId ? { lesson: { module: { course: { languageId } } } } : {}),
            },
            select: { lessonId: true, score: true },
        });
        const lessonIds = lessonsCompleted.map((l: { lessonId: any; }) => l.lessonId);
        if (lessonIds.length === 0) {
            return [] as { type: string; count: number }[];
        }

        const grouped = await prisma.exercise.groupBy({
            by: ['type'],
            where: { lessonId: { in: lessonIds } },
            _count: { _all: true },
        });

        return grouped.map((g: { type: any; _count: { _all: any; }; }) => ({ type: g.type, count: g._count._all }));
    },

    countExercisesTotal(languageId?: string) {
        return prisma.exercise.count({
            where: {
                lesson: {
                    isPublished: true,
                    deletedAt: null,
                    ...(languageId ? { module: { course: { languageId } } } : {}),
                },
            },
        });
    },

    countTranslationsLearned(userId: string, languageId?: string) {
        return prisma.userVocabulary.count({
            where: {
                userId,
                deletedAt: null,
                state: { in: ['REVIEW', 'MASTERED'] },
                ...(languageId ? { vocabulary: { languageId } } : {}),
            },
        });
    },

    countPronunciationAttempts(userId: string, languageId?: string) {
        // Approximation : sessions de review sur mots avec audioUrl (proxy de prononciation)
        return prisma.reviewSession.count({
            where: {
                userId,
                userVocabulary: {
                    vocabulary: {
                        audioUrl: { not: null },
                        ...(languageId ? { languageId } : {}),
                    },
                },
            },
        });
    },

    countListeningExercises(languageId?: string) {
        return prisma.exercise.count({
            where: {
                type: 'LISTENING',
                lesson: {
                    isPublished: true,
                    deletedAt: null,
                    ...(languageId ? { module: { course: { languageId } } } : {}),
                },
            },
        });
    },

    countWritingExercises(languageId?: string) {
        return prisma.exercise.count({
            where: {
                type: { in: ['WORD_ORDER', 'FILL_IN_THE_BLANK', 'TRANSLATION'] },
                lesson: {
                    isPublished: true,
                    deletedAt: null,
                    ...(languageId ? { module: { course: { languageId } } } : {}),
                },
            },
        });
    },

    countGrammarExercises(languageId?: string) {
        return prisma.exercise.count({
            where: {
                type: 'MULTIPLE_CHOICE',
                lesson: {
                    isPublished: true,
                    deletedAt: null,
                    ...(languageId ? { module: { course: { languageId } } } : {}),
                },
            },
        });
    },

    countReadingExercises(languageId?: string) {
        // Approximation : exercices MATCHING et lectures
        return prisma.exercise.count({
            where: {
                type: 'MATCHING',
                lesson: {
                    isPublished: true,
                    deletedAt: null,
                    ...(languageId ? { module: { course: { languageId } } } : {}),
                },
            },
        });
    },
};