import { prisma } from '../../config/prisma';

export const streakRepository = {
    findByUser(userId: string) {
        return prisma.streak.findUnique({ where: { userId } });
    },

    /** Jours d'activité entre deux dates (inclus). */
    findDailyActivityRange(userId: string, from: Date, to: Date) {
        return prisma.dailyActivity.findMany({
            where: { userId, date: { gte: from, lte: to } },
            orderBy: { date: 'asc' },
        });
    },
};