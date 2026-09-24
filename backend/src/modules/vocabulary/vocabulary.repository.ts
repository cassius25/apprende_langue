import type { Prisma, Vocabulary } from '../../generated/prisma/client';
import { prisma } from '../../config/prisma';

const vocabularyInclude = {
    language: { select: { id: true, code: true, name: true, flagEmoji: true } },
    level: { select: { id: true, code: true, name: true } },
    translations: {
        include: {
            language: { select: { id: true, code: true, name: true } },
        },
    },
    examples: { orderBy: { order: 'asc' as const } },
} satisfies Prisma.VocabularyInclude;

const userVocabularyInclude = {
    vocabulary: { include: vocabularyInclude },
} satisfies Prisma.UserVocabularyInclude;

export const vocabularyRepository = {
    // ─── Catalogue ────────────────────────────────────────────
    findCatalog(
        filter: {
            languageId?: string;
            languageCode?: string;
            levelCode?: 'A1' | 'A2' | 'B1' | 'B2' | 'C1' | 'C2';
            category?: string;
            search?: string;
        },
        pagination: { skip: number; take: number },
    ) {
        const where: Prisma.VocabularyWhereInput = {
            deletedAt: null,
            ...(filter.languageId ? { languageId: filter.languageId } : {}),
            ...(filter.languageCode ? { language: { code: filter.languageCode } } : {}),
            ...(filter.levelCode ? { level: { code: filter.levelCode } } : {}),
            ...(filter.category ? { category: filter.category } : {}),
            ...(filter.search
                ? {
                    OR: [
                        { word: { contains: filter.search, mode: 'insensitive' } },
                        { translations: { some: { translation: { contains: filter.search, mode: 'insensitive' } } } },
                    ],
                }
                : {}),
        };

        return prisma.$transaction([
            prisma.vocabulary.findMany({
                where,
                include: vocabularyInclude,
                orderBy: { word: 'asc' },
                skip: pagination.skip,
                take: pagination.take,
            }),
            prisma.vocabulary.count({ where }),
        ]);
    },

    findCatalogById(id: string) {
        return prisma.vocabulary.findFirst({
            where: { id, deletedAt: null },
            include: vocabularyInclude,
        });
    },

    create(data: Prisma.VocabularyUncheckedCreateInput): Promise<Vocabulary> {
        return prisma.vocabulary.create({ data });
    },

    update(id: string, data: Prisma.VocabularyUpdateInput): Promise<Vocabulary> {
        return prisma.vocabulary.update({ where: { id }, data });
    },

    softDelete(id: string): Promise<Vocabulary> {
        return prisma.vocabulary.update({ where: { id }, data: { deletedAt: new Date() } });
    },

    // ─── Translations ─────────────────────────────────────────
    findTranslation(vocabularyId: string, languageId: string) {
        return prisma.vocabularyTranslation.findUnique({
            where: { vocabularyId_languageId: { vocabularyId, languageId } },
        });
    },

    findTranslationById(id: string) {
        return prisma.vocabularyTranslation.findUnique({ where: { id } });
    },

    createTranslation(data: Prisma.VocabularyTranslationUncheckedCreateInput) {
        return prisma.vocabularyTranslation.create({ data });
    },

    updateTranslation(id: string, translation: string) {
        return prisma.vocabularyTranslation.update({ where: { id }, data: { translation } });
    },

    deleteTranslation(id: string) {
        return prisma.vocabularyTranslation.delete({ where: { id } });
    },

    // ─── Examples ─────────────────────────────────────────────
    findExampleById(id: string) {
        return prisma.vocabularyExample.findUnique({ where: { id } });
    },

    createExample(data: Prisma.VocabularyExampleUncheckedCreateInput) {
        return prisma.vocabularyExample.create({ data });
    },

    updateExample(id: string, data: Prisma.VocabularyExampleUpdateInput) {
        return prisma.vocabularyExample.update({ where: { id }, data });
    },

    deleteExample(id: string) {
        return prisma.vocabularyExample.delete({ where: { id } });
    },

    // ─── User vocabulary ──────────────────────────────────────
    findUserVocabulary(userId: string, vocabularyId: string) {
        return prisma.userVocabulary.findUnique({
            where: { userId_vocabularyId: { userId, vocabularyId } },
            include: userVocabularyInclude,
        });
    },

    findUserVocabularyById(userId: string, id: string) {
        return prisma.userVocabulary.findFirst({
            where: { id, userId, deletedAt: null },
            include: userVocabularyInclude,
        });
    },

    async listUserVocabulary(
        userId: string,
        filter: {
            state?: 'NEW' | 'LEARNING' | 'REVIEW' | 'MASTERED';
            isFavorite?: boolean;
            languageId?: string;
            search?: string;
        },
        pagination: { skip: number; take: number },
    ) {
        const where: Prisma.UserVocabularyWhereInput = {
            userId,
            deletedAt: null,
            ...(filter.state ? { state: filter.state } : {}),
            ...(filter.isFavorite !== undefined ? { isFavorite: filter.isFavorite } : {}),
            ...(filter.languageId ? { vocabulary: { languageId: filter.languageId } } : {}),
            ...(filter.search
                ? {
                    vocabulary: {
                        OR: [
                            { word: { contains: filter.search, mode: 'insensitive' } },
                            { translations: { some: { translation: { contains: filter.search, mode: 'insensitive' } } } },
                        ],
                    },
                }
                : {}),
        };

        return prisma.$transaction([
            prisma.userVocabulary.findMany({
                where,
                include: userVocabularyInclude,
                orderBy: [{ nextReviewAt: 'asc' }, { createdAt: 'desc' }],
                skip: pagination.skip,
                take: pagination.take,
            }),
            prisma.userVocabulary.count({ where }),
        ]);
    },

    createUserVocabulary(data: Prisma.UserVocabularyUncheckedCreateInput) {
        return prisma.userVocabulary.create({
            data,
            include: userVocabularyInclude,
        });
    },

    updateUserVocabulary(id: string, data: Prisma.UserVocabularyUpdateInput) {
        return prisma.userVocabulary.update({
            where: { id },
            data,
            include: userVocabularyInclude,
        });
    },

    /** Mots à réviser maintenant : état LEARNING/REVIEW et nextReviewAt <= now. */
    async findDue(
        userId: string,
        limit: number,
        languageId?: string,
    ) {
        const now = new Date();
        return prisma.userVocabulary.findMany({
            where: {
                userId,
                deletedAt: null,
                state: { in: ['LEARNING', 'REVIEW'] },
                OR: [{ nextReviewAt: null }, { nextReviewAt: { lte: now } }],
                ...(languageId ? { vocabulary: { languageId } } : {}),
            },
            include: userVocabularyInclude,
            orderBy: [{ nextReviewAt: 'asc' }, { createdAt: 'asc' }],
            take: limit,
        });
    },
};

export type VocabularyWithRelations = Prisma.VocabularyGetPayload<{
    include: typeof vocabularyInclude;
}>;

export type UserVocabularyWithRelations = Prisma.UserVocabularyGetPayload<{
    include: typeof userVocabularyInclude;
}>;