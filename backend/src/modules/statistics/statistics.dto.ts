export interface OverviewStatsDto {
    timeLearnedMinutes: {
        total: number;
        last7Days: number;
        last30Days: number;
    };
    words: {
        learned: number;
        mastered: number;
        reviewedTotal: number;
        dueToday: number;
    };
    exercises: {
        done: number;
        correct: number;
        successRate: number;
    };
    lessons: {
        completed: number;
        total: number;
        completionPercent: number;
    };
    xp: {
        total: number;
        level: number;
        xpInLevel: number;
        xpToNextLevel: number;
    };
    streak: {
        current: number;
        longest: number;
        totalActiveDays: number;
    };
}

export interface ActivityChartDto {
    from: string;
    to: string;
    days: {
        date: string;
        minutesLearned: number;
        xpEarned: number;
        wordsLearned: number;
        wordsReviewed: number;
        exercisesDone: number;
        exercisesCorrect: number;
    }[];
    totals: {
        minutesLearned: number;
        xpEarned: number;
        wordsLearned: number;
        wordsReviewed: number;
        exercisesDone: number;
        exercisesCorrect: number;
    };
}

export interface SkillProgressDto {
    skill: 'VOCABULARY' | 'GRAMMAR' | 'LISTENING' | 'READING' | 'SPEAKING' | 'WRITING';
    progressPercent: number;
    metrics: Record<string, number>;
}

export interface SkillsStatsDto {
    languageId: string | null;
    skills: SkillProgressDto[];
}