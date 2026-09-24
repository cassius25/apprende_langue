import type { Course, Module, Prisma } from '../../generated/prisma/client';
import { prisma } from '../../config/prisma';

const courseInclude = {
    language: { select: { id: true, code: true, name: true, flagEmoji: true } },
    level: { select: { id: true, code: true, name: true } },
    _count: {
        select: {
            modules: { where: { deletedAt: null } },
        },
    },
} satisfies Prisma.CourseInclude;

export const courseRepository = {
    findMany(
        filter: {
            languageId?: string;
            languageCode?: string;
            levelCode?: 'A1' | 'A2' | 'B1' | 'B2' | 'C1' | 'C2';
            publishedOnly: boolean;
        },
        pagination: { skip: number; take: number },
    ) {
        const where: Prisma.CourseWhereInput = {
            deletedAt: null,
            ...(filter.publishedOnly ? { isPublished: true } : {}),
            ...(filter.languageId ? { languageId: filter.languageId } : {}),
            ...(filter.languageCode ? { language: { code: filter.languageCode } } : {}),
            ...(filter.levelCode ? { level: { code: filter.levelCode } } : {}),
        };

        return prisma.$transaction([
            prisma.course.findMany({
                where,
                include: courseInclude,
                orderBy: [{ order: 'asc' }, { title: 'asc' }],
                skip: pagination.skip,
                take: pagination.take,
            }),
            prisma.course.count({ where }),
        ]);
    },

    findById(id: string) {
        return prisma.course.findFirst({
            where: { id, deletedAt: null },
            include: {
                ...courseInclude,
                modules: {
                    where: { deletedAt: null },
                    orderBy: { order: 'asc' },
                    include: {
                        lessons: {
                            where: { deletedAt: null },
                            orderBy: { order: 'asc' },
                            select: {
                                id: true,
                                title: true,
                                order: true,
                                estimatedDuration: true,
                                isPublished: true,
                            },
                        },
                    },
                },
            },
        });
    },

    create(data: Prisma.CourseUncheckedCreateInput): Promise<Course> {
        return prisma.course.create({ data });
    },

    update(id: string, data: Prisma.CourseUpdateInput): Promise<Course> {
        return prisma.course.update({ where: { id }, data });
    },

    softDelete(id: string): Promise<Course> {
        return prisma.course.update({ where: { id }, data: { deletedAt: new Date() } });
    },

    createModule(data: Prisma.ModuleUncheckedCreateInput): Promise<Module> {
        return prisma.module.create({ data });
    },
};

export type CourseWithRelations = Prisma.CourseGetPayload<{
    include: typeof courseInclude;
}>;