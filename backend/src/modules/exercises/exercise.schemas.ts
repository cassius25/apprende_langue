import { z } from 'zod';

const exerciseTypes = [
    'MULTIPLE_CHOICE',
    'TRANSLATION',
    'FILL_IN_THE_BLANK',
    'MATCHING',
    'WORD_ORDER',
    'LISTENING',
    'PRONUNCIATION',
] as const;

export const exerciseIdParamSchema = z.object({
    params: z.object({ id: z.string().uuid() }),
});

export const lessonIdParamSchema = z.object({
    params: z.object({ lessonId: z.string().uuid() }),
});

/**
 * Le format exact de `answer` dépend du type d'exercice.
 * On valide ici une forme générique ; la validation fine est faite
 * par le corrector après chargement de l'exercice.
 */
export const submitExerciseSchema = z.object({
    params: z.object({ id: z.string().uuid() }),
    body: z.object({
        answer: z.unknown(),
        responseTimeMs: z.number().int().min(0).max(600_000).optional(),
    }),
});

export const submitLessonBatchSchema = z.object({
    params: z.object({ lessonId: z.string().uuid() }),
    body: z.object({
        answers: z
            .array(
                z.object({
                    exerciseId: z.string().uuid(),
                    answer: z.unknown(),
                    responseTimeMs: z.number().int().min(0).max(600_000).optional(),
                }),
            )
            .min(1)
            .max(100),
    }),
});

// ─── Admin CRUD ─────────────────────────────────────────────
export const createExerciseSchema = z.object({
    params: z.object({ lessonId: z.string().uuid() }),
    body: z.object({
        type: z.enum(exerciseTypes),
        question: z.string().min(1).max(1000),
        correctAnswer: z.string().max(1000).optional(),
        explanation: z.string().max(2000).optional(),
        data: z.record(z.unknown()).optional(),
        order: z.number().int().nonnegative().optional(),
        options: z
            .array(
                z.object({
                    label: z.string().min(1).max(500),
                    isCorrect: z.boolean().default(false),
                    order: z.number().int().nonnegative().optional(),
                }),
            )
            .max(20)
            .optional(),
    }),
});

export const updateExerciseSchema = z.object({
    params: z.object({ id: z.string().uuid() }),
    body: z
        .object({
            question: z.string().min(1).max(1000).optional(),
            correctAnswer: z.string().max(1000).nullable().optional(),
            explanation: z.string().max(2000).nullable().optional(),
            data: z.record(z.unknown()).nullable().optional(),
            order: z.number().int().nonnegative().optional(),
        })
        .refine((b) => Object.keys(b).length > 0, { message: 'At least one field is required' }),
});

export const addOptionSchema = z.object({
    params: z.object({ id: z.string().uuid() }),
    body: z.object({
        label: z.string().min(1).max(500),
        isCorrect: z.boolean().default(false),
        order: z.number().int().nonnegative().optional(),
    }),
});

export const updateOptionSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
        optionId: z.string().uuid(),
    }),
    body: z
        .object({
            label: z.string().min(1).max(500).optional(),
            isCorrect: z.boolean().optional(),
            order: z.number().int().nonnegative().optional(),
        })
        .refine((b) => Object.keys(b).length > 0, { message: 'At least one field is required' }),
});

export const deleteOptionSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
        optionId: z.string().uuid(),
    }),
});

export type ExerciseTypeInput = (typeof exerciseTypes)[number];
export type SubmitExerciseInput = z.infer<typeof submitExerciseSchema>['body'];
export type SubmitLessonBatchInput = z.infer<typeof submitLessonBatchSchema>['body'];
export type CreateExerciseInput = z.infer<typeof createExerciseSchema>['body'];
export type UpdateExerciseInput = z.infer<typeof updateExerciseSchema>['body'];
export type AddOptionInput = z.infer<typeof addOptionSchema>['body'];
export type UpdateOptionInput = z.infer<typeof updateOptionSchema>['body'];