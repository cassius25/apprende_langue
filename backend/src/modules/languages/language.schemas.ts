import { z } from 'zod';

export const listLanguagesSchema = z.object({
    query: z.object({
        activeOnly: z
            .union([z.literal('true'), z.literal('false')])
            .optional()
            .transform((v) => v !== 'false'),
    }),
});

export const languageIdParamSchema = z.object({
    params: z.object({
        id: z.string().uuid('Invalid language id'),
    }),
});

export const createLanguageSchema = z.object({
    body: z.object({
        code: z.string().min(2).max(8).toLowerCase().trim(),
        name: z.string().min(1).max(80),
        nativeName: z.string().min(1).max(80),
        flagEmoji: z.string().max(8).optional(),
        isActive: z.boolean().optional(),
    }),
});

export const updateLanguageSchema = z.object({
    params: z.object({ id: z.string().uuid() }),
    body: z
        .object({
            code: z.string().min(2).max(8).toLowerCase().trim().optional(),
            name: z.string().min(1).max(80).optional(),
            nativeName: z.string().min(1).max(80).optional(),
            flagEmoji: z.string().max(8).nullable().optional(),
            isActive: z.boolean().optional(),
        })
        .refine((b) => Object.keys(b).length > 0, { message: 'At least one field is required' }),
});

export type CreateLanguageInput = z.infer<typeof createLanguageSchema>['body'];
export type UpdateLanguageInput = z.infer<typeof updateLanguageSchema>['body'];