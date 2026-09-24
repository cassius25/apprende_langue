import type { Lesson, Prisma } from '../../generated/prisma/client';
import { prisma } from '../../config/prisma';

export const lessonRepository = {
    findById(id: string) {
        return prisma.lesson.findFirst({
            where: { id, deletedAt: null },
            include: {
                module: {
                    include: {
                        course: {
                            include: {
                                language: { select: { id: true, code: true, name: true, flagEmoji: true } },
                                level: { select: { id: true, code: true, name: true } },
                            },
                        },
                    },
                },
                contents: { orderBy: { order: 'asc' } },
                exercises: {
                    orderBy: { order: 'asc' },
                    include: {
                        options: {
                            orderBy: { order: 'asc' },
                            select: { id: true, label: true, order: true }, // isCorrect exclu volontairement
                        },
                    },
                },
            },
        });
    },

    findProgress(userId: string, lessonId: string) {
        return prisma.userProgress.findUnique({
            where: { userId_lessonId: { userId, lessonId } },
        });
    },

    upsertProgress(
        userId: string,
        lessonId: string,
        data: { status: 'IN_PROGRESS' | 'COMPLETED'; score?: number; timeSpentSec?: number; completedAt?: Date | null },
    ) {
        return prisma.userProgress.upsert({
            where: { userId_lessonId: { userId, lessonId } },
            create: {
                userId,
                lessonId,
                status: data.status,
                score: data.score ?? 0,
                timeSpentSec: data.timeSpentSec ?? 0,
                completedAt: data.completedAt ?? null,
            },
            update: {
                status: data.status,
                ...(data.score !== undefined ? { score: data.score } : {}),
                ...(data.timeSpentSec !== undefined ? { timeSpentSec: { increment: data.timeSpentSec } } : {}),
                ...(data.completedAt !== undefined ? { completedAt: data.completedAt } : {}),
            },
        });
    },

    create(data: Prisma.LessonUncheckedCreateInput): Promise<Lesson> {
        return prisma.lesson.create({ data });
    },

    update(id: string, data: Prisma.LessonUpdateInput): Promise<Lesson> {
        return prisma.lesson.update({ where: { id }, data });
    },

    softDelete(id: string): Promise<Lesson> {
        return prisma.lesson.update({ where: { id }, data: { deletedAt: new Date() } });
    },

    findModuleById(moduleId: string) {
        return prisma.module.findFirst({ where: { id: moduleId, deletedAt: null } });
    },
};

export type LessonWithRelations = NonNullable<Awaited<ReturnType<typeof lessonRepository.findById>>>;