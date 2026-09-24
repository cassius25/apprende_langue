export interface LanguageProgressDto {
    language: { id: string; code: string; name: string; flagEmoji: string | null };
    currentLevel: { id: string; code: string; name: string } | null;
    progressPercent: number;
    isActive: boolean;
    startedAt: string;
    levels: LevelProgressDto[];
    lessonsCompleted: number;
    lessonsTotal: number;
    vocabularyLearned: number;
    vocabularyMastered: number;
}

export interface LevelProgressDto {
    id: string;
    code: string;
    name: string;
    order: number;
    progressPercent: number;
    lessonsCompleted: number;
    lessonsTotal: number;
}

export interface GlobalProgressDto {
    totalXp: number;
    userLevel: number;
    xpToNextLevel: number;
    xpInCurrentLevel: number;
    lessonsCompleted: number;
    lessonsTotal: number;
    vocabularyTotal: number;
    vocabularyMastered: number;
    languages: LanguageProgressDto[];
    currentStreak: number;
    longestStreak: number;
    dueToday: number;
}

export interface LessonProgressItemDto {
    lessonId: string;
    title: string;
    moduleTitle: string;
    courseTitle: string;
    language: { id: string; code: string; name: string; flagEmoji: string | null };
    level: { code: string; name: string };
    status: 'NOT_STARTED' | 'IN_PROGRESS' | 'COMPLETED';
    score: number;
    timeSpentSec: number;
    completedAt: string | null;
}