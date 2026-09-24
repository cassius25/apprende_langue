import { z } from 'zod';

export const lessonIdParamSchema = z.object({
    params: z.object({ id: z.string().uuid() }),
});

export const createLessonSchema = z.object({
    params: z.object({ moduleId: z.string().uuid() }),
    body: z.object({
        title: z.string().min(1).max(200),
        description: z.string().max(2000).optional(),
        order: z.number().int().nonnegative().optional(),
        estimatedDuration: z.number().int().positive().max(120).optional(),
        isPublished: z.boolean().optional(),
    }),
});

export const updateLessonSchema = z.object({
    params: z.object({ id: z.string().uuid() }),
    body: z
        .object({
            title: z.string().min(1).max(200).optional(),
            description: z.string().max(2000).nullable().optional(),
            order: z.number().int().nonnegative().optional(),
            estimatedDuration: z.number().int().positive().max(120).optional(),
            isPublished: z.boolean().optional(),
        })
        .refine((b) => Object.keys(b).length > 0, { message: 'At least one field is required' }),
});

export const completeLessonSchema = z.object({
    params: z.object({ id: z.string().uuid() }),
    body: z.object({
        score: z.number().int().min(0).max(100).optional(),
        timeSpentSec: z.number().int().min(0).max(7200).optional(),
    }),
});

export type CreateLessonInput = z.infer<typeof createLessonSchema>['body'];
export type UpdateLessonInput = z.infer<typeof updateLessonSchema>['body'];
export type CompleteLessonInput = z.infer<typeof completeLessonSchema>['body'];