import { z } from 'zod';

const cefrLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'] as const;
const vocabStates = ['NEW', 'LEARNING', 'REVIEW', 'MASTERED'] as const;

// ─────────────────────────────────────────────────────────────
// Catalogue (lecture)
// ─────────────────────────────────────────────────────────────
export const listVocabularySchema = z.object({
    query: z.object({
        languageId: z.string().uuid().optional(),
        languageCode: z.string().min(2).max(8).optional(),
        levelCode: z.enum(cefrLevels).optional(),
        category: z.string().min(1).max(80).optional(),
        search: z.string().min(1).max(120).optional(),
        page: z.coerce.number().int().positive().optional(),
        limit: z.coerce.number().int().positive().max(100).optional(),
    }),
});

export const vocabularyIdParamSchema = z.object({
    params: z.object({ id: z.string().uuid() }),
});

// ─────────────────────────────────────────────────────────────
// User — mes mots
// ─────────────────────────────────────────────────────────────
export const listMyVocabularySchema = z.object({
    query: z.object({
        state: z.enum(vocabStates).optional(),
        isFavorite: z
            .union([z.literal('true'), z.literal('false')])
            .optional()
            .transform((v) => (v === undefined ? undefined : v === 'true')),
        languageId: z.string().uuid().optional(),
        search: z.string().min(1).max(120).optional(),
        page: z.coerce.number().int().positive().optional(),
        limit: z.coerce.number().int().positive().max(100).optional(),
    }),
});

export const learnVocabularySchema = z.object({
    body: z.object({
        vocabularyId: z.string().uuid(),
    }),
});

export const favoriteVocabularySchema = z.object({
    params: z.object({ vocabularyId: z.string().uuid() }),
    body: z.object({
        isFavorite: z.boolean(),
    }),
});

export const setStateSchema = z.object({
    params: z.object({ vocabularyId: z.string().uuid() }),
    body: z.object({
        state: z.enum(vocabStates),
    }),
});

export const dueVocabularySchema = z.object({
    query: z.object({
        limit: z.coerce.number().int().positive().max(200).optional(),
        languageId: z.string().uuid().optional(),
    }),
});

// ─────────────────────────────────────────────────────────────
// Admin — contenu
// ─────────────────────────────────────────────────────────────
export const createVocabularySchema = z.object({
    body: z.object({
        languageId: z.string().uuid(),
        levelId: z.string().uuid(),
        word: z.string().min(1).max(200),
        phonetic: z.string().max(120).optional(),
        audioUrl: z.string().url().max(500).optional(),
        imageUrl: z.string().url().max(500).optional(),
        category: z.string().max(80).optional(),
        partOfSpeech: z.string().max(40).optional(),
    }),
});

export const updateVocabularySchema = z.object({
    params: z.object({ id: z.string().uuid() }),
    body: z
        .object({
            word: z.string().min(1).max(200).optional(),
            phonetic: z.string().max(120).nullable().optional(),
            audioUrl: z.string().url().max(500).nullable().optional(),
            imageUrl: z.string().url().max(500).nullable().optional(),
            category: z.string().max(80).nullable().optional(),
            partOfSpeech: z.string().max(40).nullable().optional(),
        })
        .refine((b) => Object.keys(b).length > 0, { message: 'At least one field is required' }),
});

// ── Translations ─────────────────────────────────────────────
export const createTranslationSchema = z.object({
    params: z.object({ id: z.string().uuid() }), // vocabularyId
    body: z.object({
        languageId: z.string().uuid(),
        translation: z.string().min(1).max(200),
    }),
});

export const updateTranslationSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
        translationId: z.string().uuid(),
    }),
    body: z.object({
        translation: z.string().min(1).max(200),
    }),
});

export const deleteTranslationSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
        translationId: z.string().uuid(),
    }),
});

// ── Examples ─────────────────────────────────────────────────
export const createExampleSchema = z.object({
    params: z.object({ id: z.string().uuid() }), // vocabularyId
    body: z.object({
        sentence: z.string().min(1).max(500),
        translation: z.string().max(500).optional(),
        audioUrl: z.string().url().max(500).optional(),
        order: z.number().int().nonnegative().optional(),
    }),
});

export const updateExampleSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
        exampleId: z.string().uuid(),
    }),
    body: z
        .object({
            sentence: z.string().min(1).max(500).optional(),
            translation: z.string().max(500).nullable().optional(),
            audioUrl: z.string().url().max(500).nullable().optional(),
            order: z.number().int().nonnegative().optional(),
        })
        .refine((b) => Object.keys(b).length > 0, { message: 'At least one field is required' }),
});

export const deleteExampleSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
        exampleId: z.string().uuid(),
    }),
});

// ─────────────────────────────────────────────────────────────
// Types
// ─────────────────────────────────────────────────────────────
export type ListVocabularyQuery = z.infer<typeof listVocabularySchema>['query'];
export type ListMyVocabularyQuery = z.infer<typeof listMyVocabularySchema>['query'];
export type LearnVocabularyInput = z.infer<typeof learnVocabularySchema>['body'];
export type FavoriteVocabularyInput = z.infer<typeof favoriteVocabularySchema>['body'];
export type SetStateInput = z.infer<typeof setStateSchema>['body'];
export type DueVocabularyQuery = z.infer<typeof dueVocabularySchema>['query'];
export type CreateVocabularyInput = z.infer<typeof createVocabularySchema>['body'];
export type UpdateVocabularyInput = z.infer<typeof updateVocabularySchema>['body'];
export type CreateTranslationInput = z.infer<typeof createTranslationSchema>['body'];
export type UpdateTranslationInput = z.infer<typeof updateTranslationSchema>['body'];
export type CreateExampleInput = z.infer<typeof createExampleSchema>['body'];
export type UpdateExampleInput = z.infer<typeof updateExampleSchema>['body'];
export type VocabularyState = (typeof vocabStates)[number];