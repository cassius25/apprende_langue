export type SyncOpStatus = 'APPLIED' | 'REJECTED';

export interface FailedOperationDto {
    id: string;
    reason: 'CONFLICT' | 'NOT_FOUND' | 'VALIDATION_ERROR' | 'INTERNAL_ERROR';
    message: string;
}

export interface SyncChangesDto {
    user_vocabulary: UserVocabularyChangeDto[];
    user_progress: UserProgressChangeDto[];
    daily_goals: DailyGoalChangeDto[];
    user_languages: UserLanguageChangeDto[];
    streaks: StreakChangeDto[];
    user_badges: UserBadgeChangeDto[];
    daily_activity: DailyActivityChangeDto[];
}

export interface SyncPushResponseDto {
    serverTime: string;
    applied: string[];
    failed: FailedOperationDto[];
    changes: SyncChangesDto;
    /** Nombre total d'entités renvoyées (utile pour la télémétrie). */
    changesCount: number;
}

// ─── Formes de pull (miroir des tables, sans les relations) ────

export interface UserVocabularyChangeDto {
    id: string;
    userId: string;
    vocabularyId: string;
    state: 'NEW' | 'LEARNING' | 'REVIEW' | 'MASTERED';
    isFavorite: boolean;
    repetitions: number;
    intervalDays: number;
    easeFactor: number;
    successRate: number;
    difficulty: number;
    nextReviewAt: string | null;
    lastReviewedAt: string | null;
    createdAt: string;
    updatedAt: string;
    deletedAt: string | null;
}

export interface UserProgressChangeDto {
    id: string;
    userId: string;
    lessonId: string;
    status: 'NOT_STARTED' | 'IN_PROGRESS' | 'COMPLETED';
    score: number;
    timeSpentSec: number;
    completedAt: string | null;
    createdAt: string;
    updatedAt: string;
}

export interface DailyGoalChangeDto {
    id: string;
    userId: string;
    type: 'MINUTES' | 'WORDS';
    target: number;
    isActive: boolean;
    createdAt: string;
    updatedAt: string;
}

export interface UserLanguageChangeDto {
    id: string;
    userId: string;
    languageId: string;
    levelId: string | null;
    isActive: boolean;
    progressPercent: number;
    startedAt: string;
    createdAt: string;
    updatedAt: string;
}

export interface StreakChangeDto {
    id: string;
    userId: string;
    currentStreak: number;
    longestStreak: number;
    totalActiveDays: number;
    lastActiveDate: string | null;
    updatedAt: string;
}

export interface UserBadgeChangeDto {
    id: string;
    userId: string;
    badgeId: string;
    earnedAt: string;
}

export interface DailyActivityChangeDto {
    id: string;
    userId: string;
    date: string;
    minutesLearned: number;
    wordsLearned: number;
    wordsReviewed: number;
    exercisesDone: number;
    exercisesCorrect: number;
    xpEarned: number;
    updatedAt: string;
}