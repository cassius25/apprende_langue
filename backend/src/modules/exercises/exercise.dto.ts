export type ExerciseTypeDto =
    | 'MULTIPLE_CHOICE'
    | 'TRANSLATION'
    | 'FILL_IN_THE_BLANK'
    | 'MATCHING'
    | 'WORD_ORDER'
    | 'LISTENING'
    | 'PRONUNCIATION';

/** Résultat de la correction d'un exercice. */
export interface CorrectionResult {
    exerciseId: string;
    isCorrect: boolean;
    /** 0..100 (arrondi). 100 si pleinement correct, 0 si complètement faux, palier intermédiaire pour fuzzy. */
    score: number;
    /** Fourni à titre pédagogique après soumission. */
    correctAnswer: string | null;
    explanation: string | null;
    /** Détails optionnels : distance fuzzy, paires correctes, etc. */
    details?: Record<string, unknown>;
}

/** Résultat d'une soumission unique (avec impact utilisateur). */
export interface SubmitExerciseResult extends CorrectionResult {
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

/** Résultat d'une soumission en lot (leçon complète). */
export interface SubmitLessonBatchResult {
    results: CorrectionResult[];
    correctCount: number;
    totalCount: number;
    /** Score global 0..100 (moyenne pondérée). */
    overallScore: number;
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