import { BadRequestError, NotFoundError } from '../../common/errors/HttpErrors';
import { recordActivity } from '../../common/utils/engagement';
import { correct } from './exercise.corrector';
import { exerciseRepository, type ExerciseWithSolution } from './exercise.repository';
import type {
    AddOptionInput,
    CreateExerciseInput,
    UpdateExerciseInput,
    UpdateOptionInput,
} from './exercise.schemas';
import type {
    CorrectionResult,
    SubmitExerciseResult,
    SubmitLessonBatchResult,
} from './exercise.dto';

// XP par exercice
const BASE_XP = 5;
const XP_PER_CORRECT_BONUS = 5;

function computeExerciseXp(score: number): number {
    // score 0..100 → 0..5 bonus
    return BASE_XP + Math.round((score / 100) * XP_PER_CORRECT_BONUS);
}

export const exerciseService = {
    // ────────────────────────────────────────────────────────
    // Soumission unitaire
    // ────────────────────────────────────────────────────────
    async submit(
        exerciseId: string,
        userId: string,
        answer: unknown,
        responseTimeMs?: number,
    ): Promise<SubmitExerciseResult> {
        const exercise = await exerciseRepository.findByIdWithSolution(exerciseId);
        if (!exercise) throw new NotFoundError('Exercise not found');

        const result = correct(exercise, answer);
        const xpEarned = computeExerciseXp(result.score);

        const activity = await recordActivity(userId, {
            xp: xpEarned,
            exercisesDone: 1,
            exercisesCorrect: result.isCorrect ? 1 : 0,
            markActiveDay: true,
        });

        // responseTimeMs est capturé côté client ; on le log côté serveur (futur : analytics).
        void responseTimeMs;

        return {
            ...result,
            xpEarned: activity.xpEarned,
            totalXp: activity.totalXp,
            userLevel: activity.userLevel,
            streak: activity.streak,
            newBadges: activity.newBadges,
        };
    },

    // ────────────────────────────────────────────────────────
    // Soumission batch (leçon complète)
    // ────────────────────────────────────────────────────────
    async submitLessonBatch(
        lessonId: string,
        userId: string,
        answers: { exerciseId: string; answer: unknown; responseTimeMs?: number }[],
    ): Promise<SubmitLessonBatchResult> {
        const lesson = await exerciseRepository.findLessonById(lessonId);
        if (!lesson) throw new NotFoundError('Lesson not found');

        const exercises = await exerciseRepository.findManyByLessonWithSolution(lessonId);
        if (exercises.length === 0) throw new BadRequestError('This lesson has no exercises');

        const byId = new Map<string, ExerciseWithSolution>(exercises.map((e: { id: any; }) => [e.id, e]));

        // Vérifie que tous les exerciseId fournis appartiennent à cette leçon
        for (const a of answers) {
            if (!byId.has(a.exerciseId)) {
                throw new BadRequestError(`Exercise ${a.exerciseId} does not belong to lesson ${lessonId}`);
            }
        }

        // Correction de chaque réponse
        const results: CorrectionResult[] = [];
        for (const a of answers) {
            const ex = byId.get(a.exerciseId)!;
            results.push(correct(ex, a.answer));
        }

        const correctCount = results.filter((r) => r.isCorrect).length;
        const totalCount = results.length;
        const overallScore = Math.round(
            results.reduce((acc, r) => acc + r.score, 0) / Math.max(1, totalCount),
        );

        // XP : base par exercice + bonus proportionnel au score global
        const xpEarned = results.reduce((acc, r) => acc + computeExerciseXp(r.score), 0);

        const activity = await recordActivity(userId, {
            xp: xpEarned,
            exercisesDone: totalCount,
            exercisesCorrect: correctCount,
            markActiveDay: true,
        });

        return {
            results,
            correctCount,
            totalCount,
            overallScore,
            xpEarned: activity.xpEarned,
            totalXp: activity.totalXp,
            userLevel: activity.userLevel,
            streak: activity.streak,
            newBadges: activity.newBadges,
        };
    },

    // ────────────────────────────────────────────────────────
    // Admin CRUD
    // ────────────────────────────────────────────────────────
    async create(lessonId: string, input: CreateExerciseInput) {
        const lesson = await exerciseRepository.findLessonById(lessonId);
        if (!lesson) throw new NotFoundError('Lesson not found');

        const created = await exerciseRepository.create({
            lessonId,
            type: input.type,
            question: input.question,
            correctAnswer: input.correctAnswer ?? null,
            explanation: input.explanation ?? null,
            data: input.data ?? undefined,
            order: input.order ?? 0,
        });

        if (input.options && input.options.length > 0) {
            for (let i = 0; i < input.options.length; i++) {
                const o = input.options[i];
                await exerciseRepository.createOption({
                    exerciseId: created.id,
                    label: o.label,
                    isCorrect: o.isCorrect,
                    order: o.order ?? i,
                });
            }
        }

        return this.getForAdmin(created.id);
    },

    async update(id: string, input: UpdateExerciseInput) {
        const existing = await exerciseRepository.findByIdWithSolution(id);
        if (!existing) throw new NotFoundError('Exercise not found');
        await exerciseRepository.update(id, {
            ...(input.question !== undefined ? { question: input.question } : {}),
            ...(input.correctAnswer !== undefined ? { correctAnswer: input.correctAnswer } : {}),
            ...(input.explanation !== undefined ? { explanation: input.explanation } : {}),
            ...(input.data !== undefined ? { data: input.data ?? undefined } : {}),
            ...(input.order !== undefined ? { order: input.order } : {}),
        });
        return this.getForAdmin(id);
    },

    async remove(id: string): Promise<void> {
        const existing = await exerciseRepository.findByIdWithSolution(id);
        if (!existing) throw new NotFoundError('Exercise not found');
        await exerciseRepository.delete(id); // cascade sur les options via Prisma
    },

    async addOption(exerciseId: string, input: AddOptionInput) {
        const exercise = await exerciseRepository.findByIdWithSolution(exerciseId);
        if (!exercise) throw new NotFoundError('Exercise not found');
        await exerciseRepository.createOption({
            exerciseId,
            label: input.label,
            isCorrect: input.isCorrect,
            order: input.order ?? exercise.options.length,
        });
        return this.getForAdmin(exerciseId);
    },

    async updateOption(exerciseId: string, optionId: string, input: UpdateOptionInput) {
        const opt = await exerciseRepository.findOptionById(optionId);
        if (!opt || opt.exerciseId !== exerciseId) throw new NotFoundError('Option not found');
        await exerciseRepository.updateOption(optionId, input);
        return this.getForAdmin(exerciseId);
    },

    async removeOption(exerciseId: string, optionId: string) {
        const opt = await exerciseRepository.findOptionById(optionId);
        if (!opt || opt.exerciseId !== exerciseId) throw new NotFoundError('Option not found');
        await exerciseRepository.deleteOption(optionId);
    },

    /** Vue admin : inclut correctAnswer + isCorrect. */
    async getForAdmin(id: string) {
        const ex = await exerciseRepository.findByIdWithSolution(id);
        if (!ex) throw new NotFoundError('Exercise not found');
        return {
            id: ex.id,
            lessonId: ex.lessonId,
            type: ex.type,
            question: ex.question,
            correctAnswer: ex.correctAnswer,
            explanation: ex.explanation,
            data: ex.data,
            order: ex.order,
            options: ex.options.map((o: { id: any; label: any; isCorrect: any; order: any; }) => ({
                id: o.id,
                label: o.label,
                isCorrect: o.isCorrect,
                order: o.order,
            })),
        };
    },
};