import { z } from 'zod';

export const lessonsProgressSchema = z.object({
    query: z.object({
        languageId: z.string().uuid().optional(),
        status: z.enum(['NOT_STARTED', 'IN_PROGRESS', 'COMPLETED']).optional(),
        page: z.coerce.number().int().positive().optional(),
        limit: z.coerce.number().int().positive().max(100).optional(),
    }),
});

export const languageProgressParamSchema = z.object({
    params: z.object({ languageId: z.string().uuid() }),
});

export type LessonsProgressQuery = z.infer<typeof lessonsProgressSchema>['query'];