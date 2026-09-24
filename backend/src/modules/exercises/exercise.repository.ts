import type { Exercise, ExerciseOption, Prisma } from '../../generated/prisma/client';
import { prisma } from '../../config/prisma';

/** Vue admin : contient isCorrect et correctAnswer (usage interne uniquement). */
export const exerciseRepository = {
    findByIdWithSolution(id: string) {
        return prisma.exercise.findUnique({
            where: { id },
            include: {
                options: { orderBy: { order: 'asc' } },
                lesson: { select: { id: true, title: true, moduleId: true } },
            },
        });
    },

    findManyByLessonWithSolution(lessonId: string) {
        return prisma.exercise.findMany({
            where: { lessonId },
            orderBy: { order: 'asc' },
            include: { options: { orderBy: { order: 'asc' } } },
        });
    },

    create(data: Prisma.ExerciseUncheckedCreateInput): Promise<Exercise> {
        return prisma.exercise.create({ data });
    },

    update(id: string, data: Prisma.ExerciseUpdateInput): Promise<Exercise> {
        return prisma.exercise.update({ where: { id }, data });
    },

    delete(id: string): Promise<Exercise> {
        return prisma.exercise.delete({ where: { id } });
    },

    findLessonById(lessonId: string) {
        return prisma.lesson.findFirst({ where: { id: lessonId, deletedAt: null } });
    },

    // ─── Options ─────────────────────────────────────────────
    createOption(data: Prisma.ExerciseOptionUncheckedCreateInput): Promise<ExerciseOption> {
        return prisma.exerciseOption.create({ data });
    },

    findOptionById(id: string) {
        return prisma.exerciseOption.findUnique({ where: { id } });
    },

    updateOption(id: string, data: Prisma.ExerciseOptionUpdateInput): Promise<ExerciseOption> {
        return prisma.exerciseOption.update({ where: { id }, data });
    },

    deleteOption(id: string): Promise<ExerciseOption> {
        return prisma.exerciseOption.delete({ where: { id } });
    },
};

export type ExerciseWithSolution = NonNullable<
    Awaited<ReturnType<typeof exerciseRepository.findByIdWithSolution>>
>;