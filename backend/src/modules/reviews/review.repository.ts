import type { Prisma, UserVocabulary, VocabularyState } from '../../generated/prisma/client';
import { prisma } from '../../config/prisma';

export const reviewRepository = {
    findUserVocabularyById(id: string, userId: string) {
        return prisma.userVocabulary.findFirst({
            where: { id, userId, deletedAt: null },
            include: {
                vocabulary: {
                    include: {
                        language: { select: { id: true, code: true, name: true, flagEmoji: true } },
                        level: { select: { id: true, code: true, name: true } },
                        translations: {
                            include: { language: { select: { code: true, name: true } } },
                        },
                        examples: { orderBy: { order: 'asc' } },
                    },
                },
            },
        });
    },

    /** File de révision du jour (LEARNING + REVIEW, nextReviewAt ≤ now). */
    async findDueReviews(
        userId: string,
        limit: number,
        languageId: string | undefined,
        includeNew: boolean,
    ) {
        const now = new Date();
        const states: VocabularyState[] = includeNew
            ? ['NEW', 'LEARNING', 'REVIEW']
            : ['LEARNING', 'REVIEW'];

        return prisma.userVocabulary.findMany({
            where: {
                userId,
                deletedAt: null,
                state: { in: states },
                OR: [{ nextReviewAt: null }, { nextReviewAt: { lte: now } }],
                ...(languageId ? { vocabulary: { languageId } } : {}),
            },
            include: {
                vocabulary: {
                    include: {
                        language: { select: { id: true, code: true, name: true, flagEmoji: true } },
                        level: { select: { id: true, code: true, name: true } },
                        translations: {
                            include: { language: { select: { code: true, name: true } } },
                        },
                        examples: { orderBy: { order: 'asc' }, take: 2 },
                    },
                },
            },
            orderBy: [{ nextReviewAt: 'asc' }, { createdAt: 'asc' }],
            take: limit,
        });
    },

    /** Nombre de cartes à réviser aujourd'hui (rapide, pour le dashboard). */
    countDue(userId: string): Promise<number> {
        const now = new Date();
        return prisma.userVocabulary.count({
            where: {
                userId,
                deletedAt: null,
                state: { in: ['LEARNING', 'REVIEW'] },
                OR: [{ nextReviewAt: null }, { nextReviewAt: { lte: now } }],
            },
        });
    },

    createSession(data: Prisma.ReviewSessionUncheckedCreateInput) {
        return prisma.reviewSession.create({ data });
    },

    updateUserVocabulary(id: string, data: Prisma.UserVocabularyUpdateInput): Promise<UserVocabulary> {
        return prisma.userVocabulary.update({ where: { id }, data });
    },

    /** Historique des dernières sessions (pour stats détaillées). */
    countSessionsSince(userId: string, since: Date): Promise<number> {
        return prisma.reviewSession.count({
            where: { userId, reviewedAt: { gte: since } },
        });
    },
};

export type UserVocabularyForReview = NonNullable<
    Awaited<ReturnType<typeof reviewRepository.findUserVocabularyById>>
>;