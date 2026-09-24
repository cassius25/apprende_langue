export interface LessonContentDto {
    id: string;
    type: 'TEXT' | 'IMAGE' | 'AUDIO' | 'VIDEO' | 'MARKDOWN';
    content: string;
    order: number;
}

export interface ExerciseOptionClientDto {
    id: string;
    label: string;
    order: number;
    // isCorrect volontairement omis
}

export interface ExerciseClientDto {
    id: string;
    type:
    | 'MULTIPLE_CHOICE'
    | 'TRANSLATION'
    | 'FILL_IN_THE_BLANK'
    | 'MATCHING'
    | 'WORD_ORDER'
    | 'LISTENING'
    | 'PRONUNCIATION';
    question: string;
    data: unknown;
    order: number;
    options: ExerciseOptionClientDto[];
}

export interface LessonProgressDto {
    status: 'NOT_STARTED' | 'IN_PROGRESS' | 'COMPLETED';
    score: number;
    timeSpentSec: number;
    completedAt: string | null;
}

export interface LessonDetailDto {
    id: string;
    title: string;
    description: string | null;
    order: number;
    estimatedDuration: number;
    isPublished: boolean;
    module: { id: string; title: string };
    course: { id: string; title: string };
    language: { id: string; code: string; name: string; flagEmoji: string | null };
    level: { id: string; code: string; name: string };
    contents: LessonContentDto[];
    exercises: ExerciseClientDto[];
    progress: LessonProgressDto | null;
}

export interface LessonCompletionResult {
    progress: LessonProgressDto;
    xpEarned: number;
    totalXp: number;
    userLevel: number;
    streak: {
        currentStreak: number;
        longestStreak: number;
        totalActiveDays: number;
        lastActiveDate: string | null;
    };
    newBadges: { code: string; name: string; icon: string | null }[];
}