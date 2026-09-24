import type { Language, Prisma } from '../../generated/prisma/client';
import { prisma } from '../../config/prisma';

export const languageRepository = {
    findAll(activeOnly = true): Promise<Language[]> {
        return prisma.language.findMany({
            where: {
                deletedAt: null,
                ...(activeOnly ? { isActive: true } : {}),
            },
            orderBy: { name: 'asc' },
        });
    },

    findById(id: string): Promise<Language | null> {
        return prisma.language.findFirst({ where: { id, deletedAt: null } });
    },

    findByCode(code: string): Promise<Language | null> {
        return prisma.language.findFirst({ where: { code, deletedAt: null } });
    },

    create(data: Prisma.LanguageCreateInput): Promise<Language> {
        return prisma.language.create({ data });
    },

    update(id: string, data: Prisma.LanguageUpdateInput): Promise<Language> {
        return prisma.language.update({ where: { id }, data });
    },

    softDelete(id: string): Promise<Language> {
        return prisma.language.update({ where: { id }, data: { deletedAt: new Date() } });
    },

    findLevelsByLanguage(languageId: string) {
        return prisma.level.findMany({
            orderBy: { order: 'asc' },
            where: {
                courses: { some: { languageId, deletedAt: null, isPublished: true } },
            },
        });
    },
};