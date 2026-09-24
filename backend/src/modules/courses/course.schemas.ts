import { z } from 'zod';

export const listCoursesSchema = z.object({
    query: z.object({
        languageId: z.string().uuid().optional(),
        languageCode: z.string().min(2).max(8).optional(),
        levelCode: z.enum(['A1', 'A2', 'B1', 'B2', 'C1', 'C2']).optional(),
        includeDrafts: z
            .union([z.literal('true'), z.literal('false')])
            .optional()
            .transform((v) => v === 'true'),
        page: z.coerce.number().int().positive().optional(),
        limit: z.coerce.number().int().positive().max(100).optional(),
    }),
});

export const courseIdParamSchema = z.object({
    params: z.object({ id: z.string().uuid() }),
});

export const createCourseSchema = z.object({
    body: z.object({
        languageId: z.string().uuid(),
        levelId: z.string().uuid(),
        title: z.string().min(1).max(200),
        description: z.string().max(2000).optional(),
        order: z.number().int().nonnegative().optional(),
        isPublished: z.boolean().optional(),
    }),
});

export const updateCourseSchema = z.object({
    params: z.object({ id: z.string().uuid() }),
    body: z
        .object({
            title: z.string().min(1).max(200).optional(),
            description: z.string().max(2000).nullable().optional(),
            order: z.number().int().nonnegative().optional(),
            isPublished: z.boolean().optional(),
        })
        .refine((b) => Object.keys(b).length > 0, { message: 'At least one field is required' }),
});

export const createModuleSchema = z.object({
    params: z.object({ id: z.string().uuid() }), // courseId
    body: z.object({
        title: z.string().min(1).max(200),
        description: z.string().max(2000).optional(),
        order: z.number().int().nonnegative().optional(),
    }),
});

export type ListCoursesQuery = z.infer<typeof listCoursesSchema>['query'];
export type CreateCourseInput = z.infer<typeof createCourseSchema>['body'];
export type UpdateCourseInput = z.infer<typeof updateCourseSchema>['body'];
export type CreateModuleInput = z.infer<typeof createModuleSchema>['body'];