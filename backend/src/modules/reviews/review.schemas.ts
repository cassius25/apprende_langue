import { z } from 'zod';

export const submitReviewSchema = z.object({
    body: z.object({
        userVocabularyId: z.string().uuid(),
        quality: z.number().int().min(0).max(5),
        responseTimeMs: z.number().int().min(0).max(600_000).optional(),
    }),
});

export const submitBatchReviewsSchema = z.object({
    body: z.object({
        reviews: z
            .array(
                z.object({
                    userVocabularyId: z.string().uuid(),
                    quality: z.number().int().min(0).max(5),
                    responseTimeMs: z.number().int().min(0).max(600_000).optional(),
                }),
            )
            .min(1)
            .max(200),
    }),
});

export const todayReviewsSchema = z.object({
    query: z.object({
        limit: z.coerce.number().int().positive().max(200).optional(),
        languageId: z.string().uuid().optional(),
        includeNew: z
            .union([z.literal('true'), z.literal('false')])
            .optional()
            .transform((v) => v === 'true'),
    }),
});

export type SubmitReviewInput = z.infer<typeof submitReviewSchema>['body'];
export type SubmitBatchReviewsInput = z.infer<typeof submitBatchReviewsSchema>['body'];
export type TodayReviewsQuery = z.infer<typeof todayReviewsSchema>['query'];