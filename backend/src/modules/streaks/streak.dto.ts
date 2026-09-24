export interface StreakDto {
    currentStreak: number;
    longestStreak: number;
    totalActiveDays: number;
    lastActiveDate: string | null;
    /** Jours actifs sur la période courante (équivalent "cette semaine" côté client). */
    activeToday: boolean;
    daysUntilStreakLoss: number;
}

export interface CalendarDayDto {
    date: string; // YYYY-MM-DD
    active: boolean;
    minutesLearned: number;
    xpEarned: number;
    wordsLearned: number;
    wordsReviewed: number;
    exercisesDone: number;
}

export interface StreakCalendarDto {
    from: string;
    to: string;
    days: CalendarDayDto[];
}