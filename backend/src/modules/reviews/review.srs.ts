import type { VocabularyState } from '../../generated/prisma/client';

export interface SrsInput {
    repetitions: number;
    intervalDays: number;
    easeFactor: number;
    successRate: number;
}

export interface SrsOutput {
    repetitions: number;
    intervalDays: number;
    easeFactor: number;
    successRate: number;
    difficulty: number; // 0..1
    state: VocabularyState;
    nextReviewAt: Date;
    isCorrect: boolean;
}

/** Bornes de sécurité */
const MIN_EASE_FACTOR = 1.3;
const MAX_EASE_FACTOR = 3.0;
const MAX_INTERVAL_DAYS = 365;
const SUCCESS_RATE_EMA_ALPHA = 0.3;
const MASTERED_REPETITIONS_THRESHOLD = 5;
const MASTERED_INTERVAL_THRESHOLD = 21;

/** Renvoie "true" si la qualité indique une réussite (SM-2 : q >= 3). */
function isSuccessQuality(q: number): boolean {
    return q >= 3;
}

/** Détermine l'état à partir des paramètres SRS. */
export function deriveState(
    repetitions: number,
    intervalDays: number,
    previousState: VocabularyState,
): VocabularyState {
    if (repetitions === 0) return 'LEARNING';
    if (repetitions >= MASTERED_REPETITIONS_THRESHOLD && intervalDays >= MASTERED_INTERVAL_THRESHOLD) {
        return 'MASTERED';
    }
    if (previousState === 'NEW') return 'LEARNING';
    return repetitions >= 2 ? 'REVIEW' : 'LEARNING';
}

/** Calcule la prochaine échéance en jours selon SM-2. */
function computeNextIntervalDays(q: number, repetitions: number, currentInterval: number, ef: number): number {
    if (!isSuccessQuality(q)) return 1;
    if (repetitions === 0) return 1;
    if (repetitions === 1) return 6;
    return Math.min(MAX_INTERVAL_DAYS, Math.max(1, Math.round(currentInterval * ef)));
}

/** Ease factor SM-2 avec bornes. */
function computeNewEaseFactor(q: number, ef: number): number {
    const delta = 0.1 - (5 - q) * (0.08 + (5 - q) * 0.02);
    return Math.min(MAX_EASE_FACTOR, Math.max(MIN_EASE_FACTOR, ef + delta));
}

/** Applique SM-2 complet. */
export function applySrs(input: SrsInput, quality: number, previousState: VocabularyState): SrsOutput {
    const q = Math.max(0, Math.min(5, Math.round(quality)));
    const isCorrect = isSuccessQuality(q);

    // ─── Ease factor ──────────────────────────────────────────
    const newEf = computeNewEaseFactor(q, input.easeFactor);

    // ─── Repetitions & intervalle ─────────────────────────────
    let repetitions: number;
    let intervalDays: number;

    if (!isCorrect) {
        repetitions = 0;
        intervalDays = 1;
    } else {
        intervalDays = computeNextIntervalDays(q, input.repetitions, input.intervalDays, newEf);
        repetitions = input.repetitions + 1;
    }

    // ─── Taux de réussite (EMA) ───────────────────────────────
    const successRate =
        input.successRate === 0
            ? isCorrect
                ? 1
                : 0
            : input.successRate * (1 - SUCCESS_RATE_EMA_ALPHA) + (isCorrect ? 1 : 0) * SUCCESS_RATE_EMA_ALPHA;

    // ─── Difficulté normalisée 0..1 (dérivée de l'EF) ─────────
    const difficulty = Math.max(0, Math.min(1, (2.5 - newEf) / 1.2));

    // ─── État ─────────────────────────────────────────────────
    const state = deriveState(repetitions, intervalDays, previousState);

    // ─── Prochaine révision ───────────────────────────────────
    const nextReviewAt = new Date(Date.now() + intervalDays * 24 * 60 * 60 * 1000);

    return {
        repetitions,
        intervalDays,
        easeFactor: Number(newEf.toFixed(3)),
        successRate: Number(successRate.toFixed(3)),
        difficulty: Number(difficulty.toFixed(3)),
        state,
        nextReviewAt,
        isCorrect,
    };
}