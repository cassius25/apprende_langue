export interface GoalDto {
    id: string;
    type: 'MINUTES' | 'WORDS';
    target: number;
    isActive: boolean;
    createdAt: string;
    updatedAt: string;
}

export interface TodayGoalProgressDto {
    goal: GoalDto | null;
    current: number;
    target: number;
    progressPercent: number;
    achieved: boolean;
    /** Détail complémentaire pour l'écran d'accueil. */
    minutesLearned: number;
    wordsLearned: number;
}