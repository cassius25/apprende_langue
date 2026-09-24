import { streakRepository } from './streak.repository';
import type { CalendarDayDto, StreakCalendarDto, StreakDto } from './streak.dto';

function todayUtc(): Date {
    const now = new Date();
    return new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
}

function dayKey(d: Date): string {
    return d.toISOString().slice(0, 10);
}

export const streakService = {
    async get(userId: string): Promise<StreakDto> {
        const s = await streakRepository.findByUser(userId);
        const today = todayUtc();

        if (!s) {
            return {
                currentStreak: 0,
                longestStreak: 0,
                totalActiveDays: 0,
                lastActiveDate: null,
                activeToday: false,
                daysUntilStreakLoss: 0,
            };
        }

        const last = s.lastActiveDate;
        const activeToday = last ? dayKey(last) === dayKey(today) : false;

        let daysUntilStreakLoss = 0;
        if (last) {
            const diffDays = Math.round((today.getTime() - last.getTime()) / (24 * 60 * 60 * 1000));
            // 0 : actif aujourd'hui → 1 jour pour continuer demain
            // 1 : actif hier      → encore 1 jour pour "sauver" la série
            // ≥2 : série perdue
            if (diffDays <= 1) daysUntilStreakLoss = Math.max(0, 1 - diffDays);
            else daysUntilStreakLoss = 0;
        }

        return {
            currentStreak: s.currentStreak,
            longestStreak: s.longestStreak,
            totalActiveDays: s.totalActiveDays,
            lastActiveDate: last ? dayKey(last) : null,
            activeToday,
            daysUntilStreakLoss,
        };
    },

    async getCalendar(userId: string, days = 30, offset = 0): Promise<StreakCalendarDto> {
        const to = todayUtc();
        to.setUTCDate(to.getUTCDate() - offset);

        const from = new Date(to);
        from.setUTCDate(from.getUTCDate() - (days - 1));

        const rows = await streakRepository.findDailyActivityRange(userId, from, to);
        const byDate = new Map(rows.map((r) => [dayKey(r.date), r]));

        const calendar: CalendarDayDto[] = [];
        for (let i = 0; i < days; i++) {
            const d = new Date(from);
            d.setUTCDate(d.getUTCDate() + i);
            const key = dayKey(d);
            const r = byDate.get(key);

            const active =
                !!r &&
                (r.xpEarned > 0 ||
                    r.minutesLearned > 0 ||
                    r.wordsLearned > 0 ||
                    r.wordsReviewed > 0 ||
                    r.exercisesDone > 0);

            calendar.push({
                date: key,
                active,
                minutesLearned: r?.minutesLearned ?? 0,
                xpEarned: r?.xpEarned ?? 0,
                wordsLearned: r?.wordsLearned ?? 0,
                wordsReviewed: r?.wordsReviewed ?? 0,
                exercisesDone: r?.exercisesDone ?? 0,
            });
        }

        return { from: dayKey(from), to: dayKey(to), days: calendar };
    },
};