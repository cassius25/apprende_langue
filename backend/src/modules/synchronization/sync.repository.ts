import type { Prisma, SyncStatus } from '../../generated/prisma/client';
import { prisma } from '../../config/prisma';

export const syncRepository = {
    // ─── Journal d'opérations ─────────────────────────────────
    findOperationById(userId: string, id: string) {
        return prisma.syncOperation.findFirst({ where: { id, userId } });
    },

    createOperation(data: Prisma.SyncOperationUncheckedCreateInput) {
        return prisma.syncOperation.create({ data });
    },

    updateOperationStatus(id: string, status: SyncStatus, errorMessage?: string) {
        return prisma.syncOperation.update({
            where: { id },
            data: { status, errorMessage: errorMessage ?? null },
        });
    },

    // ─── Pull incrémental ─────────────────────────────────────
    findUserVocabularySince(userId: string, since: Date) {
        return prisma.userVocabulary.findMany({
            where: { userId, updatedAt: { gt: since } },
            orderBy: { updatedAt: 'asc' },
        });
    },

    findUserProgressSince(userId: string, since: Date) {
        return prisma.userProgress.findMany({
            where: { userId, updatedAt: { gt: since } },
            orderBy: { updatedAt: 'asc' },
        });
    },

    findDailyGoalsSince(userId: string, since: Date) {
        return prisma.dailyGoal.findMany({
            where: { userId, updatedAt: { gt: since } },
            orderBy: { updatedAt: 'asc' },
        });
    },

    findUserLanguagesSince(userId: string, since: Date) {
        return prisma.userLanguage.findMany({
            where: { userId, updatedAt: { gt: since } },
            orderBy: { updatedAt: 'asc' },
        });
    },

    findStreak(userId: string) {
        return prisma.streak.findUnique({ where: { userId } });
    },

    findUserBadgesSince(userId: string, since: Date) {
        return prisma.userBadge.findMany({
            where: { userId, earnedAt: { gt: since } },
            orderBy: { earnedAt: 'asc' },
        });
    },

    findDailyActivitySince(userId: string, since: Date) {
        return prisma.dailyActivity.findMany({
            where: { userId, updatedAt: { gt: since } },
            orderBy: { date: 'asc' },
        });
    },

    // ─── Helpers de conflit ───────────────────────────────────
    findUserVocabularyByNaturalKey(userId: string, vocabularyId: string) {
        return prisma.userVocabulary.findUnique({
            where: { userId_vocabularyId: { userId, vocabularyId } },
        });
    },

    findUserProgressByNaturalKey(userId: string, lessonId: string) {
        return prisma.userProgress.findUnique({
            where: { userId_lessonId: { userId, lessonId } },
        });
    },

    findDailyGoalByNaturalKey(userId: string, type: 'MINUTES' | 'WORDS') {
        return prisma.dailyGoal.findFirst({ where: { userId, type } });
    },

    findUserLanguageByNaturalKey(userId: string, languageId: string) {
        return prisma.userLanguage.findUnique({
            where: { userId_languageId: { userId, languageId } },
        });
    },

    // ─── Écritures directes ───────────────────────────────────
    async upsertUserVocabulary(
        userId: string,
        vocabularyId: string,
        data: Omit<Prisma.UserVocabularyUncheckedCreateInput, 'userId' | 'vocabularyId'>,
    ) {
        return prisma.userVocabulary.upsert({
            where: { userId_vocabularyId: { userId, vocabularyId } },
            create: { userId, vocabularyId, ...data },
            update: data,
        });
    },

    async upsertUserProgress(
        userId: string,
        lessonId: string,
        data: Omit<Prisma.UserProgressUncheckedCreateInput, 'userId' | 'lessonId'>,
    ) {
        return prisma.userProgress.upsert({
            where: { userId_lessonId: { userId, lessonId } },
            create: { userId, lessonId, ...data },
            update: data,
        });
    },

    async upsertDailyGoal(
        userId: string,
        type: 'MINUTES' | 'WORDS',
        data: Omit<Prisma.DailyGoalUncheckedCreateInput, 'userId' | 'type'>,
    ) {
        const existing = await prisma.dailyGoal.findFirst({ where: { userId, type } });
        if (existing) {
            return prisma.dailyGoal.update({ where: { id: existing.id }, data });
        }
        return prisma.dailyGoal.create({ data: { userId, type, ...data } });
    },

    async upsertUserLanguage(
        userId: string,
        languageId: string,
        data: Omit<Prisma.UserLanguageUncheckedCreateInput, 'userId' | 'languageId'>,
    ) {
        return prisma.userLanguage.upsert({
            where: { userId_languageId: { userId, languageId } },
            create: { userId, languageId, ...data },
            update: data,
        });
    },

    async softDeleteUserVocabulary(userId: string, vocabularyId: string) {
        return prisma.userVocabulary.update({
            where: { userId_vocabularyId: { userId, vocabularyId } },
            data: { deletedAt: new Date() },
        });
    },

    // ─── Vérification d'existence des dépendances ─────────────
    countVocabularyById(vocabularyId: string) {
        return prisma.vocabulary.count({ where: { id: vocabularyId, deletedAt: null } });
    },

    countLessonById(lessonId: string) {
        return prisma.lesson.count({ where: { id: lessonId, deletedAt: null } });
    },

    countLanguageById(languageId: string) {
        return prisma.language.count({ where: { id: languageId, deletedAt: null } });
    },

    findLevelById(levelId: string) {
        return prisma.level.findUnique({ where: { id: levelId } });
    },
};