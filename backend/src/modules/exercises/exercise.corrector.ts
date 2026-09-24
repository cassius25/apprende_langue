import { BadRequestError } from '../../common/errors/HttpErrors';
import { fuzzyEquals, normalizeText, normalizeWordSequence, similarity, tokenize } from '../../common/utils/text';
import type { CorrectionResult } from './exercise.dto';
import type { ExerciseWithSolution } from './exercise.repository';

// ─────────────────────────────────────────────────────────────
// Garde de type pour les réponses côté client
// ─────────────────────────────────────────────────────────────
function asRecord(v: unknown, field: string): Record<string, unknown> {
    if (typeof v !== 'object' || v === null || Array.isArray(v)) {
        throw new BadRequestError(`Invalid answer: "${field}" must be an object`);
    }
    return v as Record<string, unknown>;
}

function asString(v: unknown, field: string): string {
    if (typeof v !== 'string') {
        throw new BadRequestError(`Invalid answer: "${field}" must be a string`);
    }
    return v;
}

function asStringArray(v: unknown, field: string): string[] {
    if (!Array.isArray(v) || v.some((x) => typeof x !== 'string')) {
        throw new BadRequestError(`Invalid answer: "${field}" must be an array of strings`);
    }
    return v as string[];
}

// ─────────────────────────────────────────────────────────────
// Seuils
// ─────────────────────────────────────────────────────────────
const TRANSLATION_FUZZY_THRESHOLD = 0.9;   // stricte mais tolère typos légères
const FILL_IN_FUZZY_THRESHOLD = 0.92;
const WORD_ORDER_FUZZY_THRESHOLD = 0.9;
const LISTENING_FUZZY_THRESHOLD = 0.9;

// ─────────────────────────────────────────────────────────────
// Corrector
// ─────────────────────────────────────────────────────────────
export function correct(exercise: ExerciseWithSolution, rawAnswer: unknown): CorrectionResult {
    switch (exercise.type) {
        case 'MULTIPLE_CHOICE':
            return correctMultipleChoice(exercise, rawAnswer);
        case 'FILL_IN_THE_BLANK':
            return correctFillInTheBlank(exercise, rawAnswer);
        case 'TRANSLATION':
            return correctTranslation(exercise, rawAnswer);
        case 'MATCHING':
            return correctMatching(exercise, rawAnswer);
        case 'WORD_ORDER':
            return correctWordOrder(exercise, rawAnswer);
        case 'LISTENING':
            return correctListening(exercise, rawAnswer);
        case 'PRONUNCIATION':
            return correctPronunciation(exercise, rawAnswer);
        default:
            throw new BadRequestError(`Unsupported exercise type: ${exercise.type}`);
    }
}

// ─────────────────────────────────────────────────────────────
// MULTIPLE_CHOICE
// ─────────────────────────────────────────────────────────────
function correctMultipleChoice(ex: ExerciseWithSolution, raw: unknown): CorrectionResult {
    const answer = asRecord(raw, 'answer');
    const optionId = asString(answer.optionId, 'answer.optionId');

    const option = ex.options.find((o: { id: string; }) => o.id === optionId);
    if (!option) throw new BadRequestError('Invalid optionId');

    const isCorrect = option.isCorrect;
    const correctOption = ex.options.find((o: { isCorrect: any; }) => o.isCorrect);

    return {
        exerciseId: ex.id,
        isCorrect,
        score: isCorrect ? 100 : 0,
        correctAnswer: correctOption?.label ?? null,
        explanation: ex.explanation,
        details: { submittedOptionId: optionId },
    };
}

// ─────────────────────────────────────────────────────────────
// FILL_IN_THE_BLANK — accepte optionId ou texte libre
// ─────────────────────────────────────────────────────────────
function correctFillInTheBlank(ex: ExerciseWithSolution, raw: unknown): CorrectionResult {
    const answer = asRecord(raw, 'answer');
    const correctOption = ex.options.find((o: { isCorrect: any; }) => o.isCorrect);

    // Cas 1 : QCM (optionId)
    if (typeof answer.optionId === 'string') {
        const option = ex.options.find((o: { id: unknown; }) => o.id === answer.optionId);
        if (!option) throw new BadRequestError('Invalid optionId');
        const isCorrect = option.isCorrect;
        return {
            exerciseId: ex.id,
            isCorrect,
            score: isCorrect ? 100 : 0,
            correctAnswer: correctOption?.label ?? ex.correctAnswer ?? null,
            explanation: ex.explanation,
            details: { submittedOptionId: option.id },
        };
    }

    // Cas 2 : saisie texte
    if (typeof answer.text === 'string') {
        const expected = ex.correctAnswer ?? correctOption?.label ?? '';
        if (!expected) throw new BadRequestError('Exercise has no expected answer configured');
        const sim = similarity(
            normalizeText(answer.text, { stripAccents: true }),
            normalizeText(expected, { stripAccents: true }),
        );
        const isCorrect = sim >= FILL_IN_FUZZY_THRESHOLD;
        return {
            exerciseId: ex.id,
            isCorrect,
            score: isCorrect ? 100 : Math.round(sim * 100),
            correctAnswer: expected,
            explanation: ex.explanation,
            details: { similarity: Number(sim.toFixed(3)) },
        };
    }

    throw new BadRequestError('Invalid answer: expected { optionId } or { text }');
}

// ─────────────────────────────────────────────────────────────
// TRANSLATION — comparaison floue (tolère accents, casse, typos légères)
// ─────────────────────────────────────────────────────────────
function correctTranslation(ex: ExerciseWithSolution, raw: unknown): CorrectionResult {
    const answer = asRecord(raw, 'answer');
    const text = asString(answer.text, 'answer.text');
    const expected = ex.correctAnswer ?? '';
    if (!expected) throw new BadRequestError('Exercise has no expected translation configured');

    // Supporte plusieurs variantes séparées par " | "
    const variants = expected
        .split('|')
        .map((v: string) => v.trim())
        .filter(Boolean);

    let bestSim = 0;
    let matched = false;
    for (const v of variants) {
        if (fuzzyEquals(text, v, TRANSLATION_FUZZY_THRESHOLD)) {
            matched = true;
            bestSim = 1;
            break;
        }
        bestSim = Math.max(bestSim, similarity(normalizeText(text, { stripAccents: true }), normalizeText(v, { stripAccents: true })));
    }

    return {
        exerciseId: ex.id,
        isCorrect: matched,
        score: matched ? 100 : Math.round(bestSim * 100),
        correctAnswer: variants[0],
        explanation: ex.explanation,
        details: { similarity: Number(bestSim.toFixed(3)) },
    };
}

// ─────────────────────────────────────────────────────────────
// MATCHING — l'ordre des paires n'importe pas, mais les associations oui
// ─────────────────────────────────────────────────────────────
function correctMatching(ex: ExerciseWithSolution, raw: unknown): CorrectionResult {
    const answer = asRecord(raw, 'answer');
    const pairs = answer.pairs;
    if (!Array.isArray(pairs)) throw new BadRequestError('Invalid answer: "pairs" must be an array');

    const expectedPairs = extractExpectedPairs(ex);
    const expectedMap = new Map(expectedPairs.map((p) => [p.left, p.right]));

    let correct = 0;
    const seen = new Set<string>();
    for (const rawPair of pairs) {
        const p = asRecord(rawPair, 'answer.pairs[i]');
        const left = asString(p.left, 'answer.pairs[i].left');
        const right = asString(p.right, 'answer.pairs[i].right');
        if (seen.has(left)) continue; // doublon, on ignore
        seen.add(left);
        const expectedRight = expectedMap.get(left);
        if (expectedRight && fuzzyEquals(right, expectedRight, 0.95)) correct++;
    }

    const total = expectedPairs.length || 1;
    const score = Math.round((correct / total) * 100);
    const isCorrect = correct === total;

    return {
        exerciseId: ex.id,
        isCorrect,
        score,
        correctAnswer: expectedPairs.map((p) => `${p.left} → ${p.right}`).join('\n'),
        explanation: ex.explanation,
        details: { correctPairs: correct, totalPairs: total },
    };
}

function extractExpectedPairs(ex: ExerciseWithSolution): { left: string; right: string }[] {
    const data = ex.data as { pairs?: unknown } | null;
    if (!data || !Array.isArray(data.pairs)) {
        throw new BadRequestError('Exercise data.pairs is missing or malformed');
    }
    return data.pairs
        .map((raw) => {
            const p = asRecord(raw, 'data.pairs[i]');
            return { left: asString(p.left, 'data.pairs[i].left'), right: asString(p.right, 'data.pairs[i].right') };
        });
}

// ─────────────────────────────────────────────────────────────
// WORD_ORDER — ensemble des mots identique + ordre correct
// ─────────────────────────────────────────────────────────────
function correctWordOrder(ex: ExerciseWithSolution, raw: unknown): CorrectionResult {
    const answer = asRecord(raw, 'answer');
    const words = asStringArray(answer.words, 'answer.words');

    const expected = ex.correctAnswer ?? '';
    if (!expected) throw new BadRequestError('Exercise has no expected sentence configured');

    const submitted = normalizeWordSequence(words);
    const target = normalizeWordSequence(tokenize(expected));

    // Détection : mêmes mots, mauvais ordre ?
    const sameMultiset = sameWordMultiset(words, tokenize(expected));

    const exact = submitted === target;
    const sim = similarity(submitted, target);
    const isCorrect = exact;

    let score: number;
    if (exact) score = 100;
    else if (sameMultiset) score = 60; // bonnes briques, mauvais ordre
    else score = Math.round(sim * 50);

    return {
        exerciseId: ex.id,
        isCorrect,
        score,
        correctAnswer: expected,
        explanation: ex.explanation,
        details: {
            submitted: submitted,
            expected: target,
            sameWordsDifferentOrder: sameMultiset && !exact,
        },
    };
}

function sameWordMultiset(a: string[], b: string[]): boolean {
    const na = a.map((w) => normalizeText(w, { stripAccents: true })).sort();
    const nb = b.map((w) => normalizeText(w, { stripAccents: true })).sort();
    if (na.length !== nb.length) return false;
    return na.every((w, i) => w === nb[i]);
}

// ─────────────────────────────────────────────────────────────
// LISTENING — comme QCM ou texte libre
// ─────────────────────────────────────────────────────────────
function correctListening(ex: ExerciseWithSolution, raw: unknown): CorrectionResult {
    // Réutilise la logique fill-in : accepte optionId ou text
    const result = correctFillInTheBlank(ex, raw);
    return { ...result, exerciseId: ex.id };
}

// ─────────────────────────────────────────────────────────────
// PRONUNCIATION — stub : compare une transcription fournie
// (l'intégration STT réelle se fera via un service externe)
// ─────────────────────────────────────────────────────────────
function correctPronunciation(ex: ExerciseWithSolution, raw: unknown): CorrectionResult {
    const answer = asRecord(raw, 'answer');
    const target = ex.correctAnswer ?? ex.question;
    const transcription = typeof answer.transcription === 'string' ? answer.transcription : null;

    if (!transcription) {
        // Pas de moteur STT : on accepte et on renvoie un score neutre
        return {
            exerciseId: ex.id,
            isCorrect: true,
            score: 100,
            correctAnswer: target,
            explanation: ex.explanation ?? 'Prononciation enregistrée.',
            details: { mode: 'no-stt', message: 'Speech-to-text non configuré — réponse acceptée par défaut.' },
        };
    }

    const sim = similarity(
        normalizeText(transcription, { stripAccents: true }),
        normalizeText(target, { stripAccents: true }),
    );
    const isCorrect = sim >= 0.85;

    return {
        exerciseId: ex.id,
        isCorrect,
        score: Math.round(sim * 100),
        correctAnswer: target,
        explanation: ex.explanation,
        details: { mode: 'text-comparison', similarity: Number(sim.toFixed(3)) },
    };
}