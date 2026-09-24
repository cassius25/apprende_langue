import { prisma } from '../../config/prisma';

export const progressRepository = {
    getUserXp(userId: string) {
        return prisma.user.findUnique({
            where: { id: userId },
            select: { xp: true, userLevel: true },
        });
    },

    /** Nombre total de leçons publiées pour une langue donnée. */
    countPublishedLessons(languageId?: string) {
        return prisma.lesson.count({
            where: {
                isPublished: true,
                deletedAt: null,
                ...(languageId ? { module: { course: { languageId, deletedAt: null } } } : {}),
            },
        });
    },

    /** Leçons complétées pour un utilisateur (optionnellement filtrées par langue). */
    countCompletedLessons(userId: string, languageId?: string) {
        return prisma.userProgress.count({
            where: {
                userId,
                status: 'COMPLETED',
                ...(languageId ? { lesson: { module: { course: { languageId } } } } : {}),
            },
        });
    },

    /** Liste des langues actives d'un utilisateur. */
    findUserLanguages(userId: string) {
        return prisma.userLanguage.findMany({
            where: { userId, isActive: true },
            include: {
                language: { select: { id: true, code: true, name: true, flagEmoji: true } },
            },
        });
    },

    /** Progression par niveau CECRL pour une langue donnée. */
    async levelProgress(userId: string, languageId: string) {
        const levels = await prisma.level.findMany({ orderBy: { order: 'asc' } });

        const result: {
            id: string;
            code: string;
            name: string;
            order: number;
            lessonsCompleted: number;
            lessonsTotal: number;
        }[] = [];

        for (const level of levels) {
            const lessonsTotal = await prisma.lesson.count({
                where: {
                    isPublished: true,
                    deletedAt: null,
                    module: { course: { languageId, levelId: level.id, deletedAt: null } },
                },
            });

            const lessonsCompleted = await prisma.userProgress.count({
                where: {
                    userId,
                    status: 'COMPLETED',
                    lesson: { module: { course: { languageId, levelId: level.id } } },
                },
            });

            result.push({
                id: level.id,
                code: level.code,
                name: level.name,
                order: level.order,
                lessonsCompleted,
                lessonsTotal,
            });
        }
        return result;
    },

    /** Stats de vocabulaire utilisateur (total + mastered) pour une langue. */
    async vocabularyStats(userId: string, languageId: string) {
        const [total, mastered] = await prisma.$transaction([
            prisma.userVocabulary.count({
                where: { userId, deletedAt: null, vocabulary: { languageId } },
            }),
            prisma.userVocabulary.count({
                where: { userId, deletedAt: null, state: 'MASTERED', vocabulary: { languageId } },
            }),
        ]);
        return { total, mastered };
    },

    /** Liste paginée des leçons avec progression utilisateur. */
    async listLessonsWithProgress(
        userId: string,
        filter: { languageId?: string; status?: 'NOT_STARTED' | 'IN_PROGRESS' | 'COMPLETED' },
        pagination: { skip: number; take: number },
    ) {
        const where = {
            isPublished: true,
            deletedAt: null,
            ...(filter.languageId ? { module: { course: { languageId: filter.languageId } } } : {}),
            ...(filter.status
                ? {
                    userProgress: {
                        some: { userId, status: filter.status },
                    },
                }
                : {}),
        };

        const [lessons, total] = await prisma.$transaction([
            prisma.lesson.findMany({
                where,
                include: {
                    module: {
                        include: {
                            course: {
                                include: {
                                    language: { select: { id: true, code: true, name: true, flagEmoji: true } },
                                    level: { select: { code: true, name: true } },
                                },
                            },
                        },
                    },
                    userProgress: { where: { userId } },
                },
                orderBy: [{ module: { course: { order: 'asc' } } }, { order: 'asc' }],
                skip: pagination.skip,
                take: pagination.take,
            }),
            prisma.lesson.count({ where }),
        ]);

        return { lessons, total };
    },
};