import type { DailyGoal, Prisma } from '../../generated/prisma/client';
import { prisma } from '../../config/prisma';

export const goalRepository = {
    findByUser(userId: string): Promise<DailyGoal[]> {
        return prisma.dailyGoal.findMany({
            where: { userId, isActive: true },
            orderBy: { createdAt: 'asc' },
        });
    },

    findById(id: string): Promise<DailyGoal | null> {
        return prisma.dailyGoal.findUnique({ where: { id } });
    },

    findByUserAndType(userId: string, type: 'MINUTES' | 'WORDS'): Promise<DailyGoal | null> {
        return prisma.dailyGoal.findFirst({ where: { userId, type, isActive: true } });
    },

    create(data: Prisma.DailyGoalUncheckedCreateInput): Promise<DailyGoal> {
        return prisma.dailyGoal.create({ data });
    },

    update(id: string, data: Prisma.DailyGoalUpdateInput): Promise<DailyGoal> {
        return prisma.dailyGoal.update({ where: { id }, data });
    },

    delete(id: string): Promise<DailyGoal> {
        return prisma.dailyGoal.delete({ where: { id } });
    },

    getTodayActivity(userId: string, date: Date) {
        return prisma.dailyActivity.findUnique({
            where: { userId_date: { userId, date } },
        });
    },
};