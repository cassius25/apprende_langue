export type VocabularyStateDto = 'NEW' | 'LEARNING' | 'REVIEW' | 'MASTERED';

export interface ReviewCardDto {
    userVocabularyId: string;
    vocabularyId: string;
    word: string;
    phonetic: string | null;
    audioUrl: string | null;
    imageUrl: string | null;
    translations: { languageCode: string; translation: string }[];
    examples: { sentence: string; translation: string | null }[];
    state: VocabularyStateDto;
    repetitions: number;
    intervalDays: number;
    easeFactor: number;
    nextReviewAt: string | null;
}

export interface ReviewResultDto {
    userVocabularyId: string;
    quality: number;
    isCorrect: boolean;
    previous: {
        state: VocabularyStateDto;
        repetitions: number;
        intervalDays: number;
        easeFactor: number;
    };
    current: {
        state: VocabularyStateDto;
        repetitions: number;
        intervalDays: number;
        easeFactor: number;
        successRate: number;
        difficulty: number;
        nextReviewAt: string;
    };
    nextReviewInDays: number;
}

export interface SubmitReviewResponse extends ReviewResultDto {
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

export interface SubmitBatchReviewsResponse {
    results: ReviewResultDto[];
    totalXpEarned: number;
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