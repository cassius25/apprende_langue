import { z } from 'zod';
import { changePasswordSchema as changePwdBody } from '../auth/auth.schemas';

export const updateMeSchema = z.object({
    body: z.object({
        firstName: z.string().min(1).max(80).optional(),
        lastName: z.string().min(1).max(80).optional(),
        nativeLanguageId: z.string().uuid().nullable().optional(),
    }),
});

export const deleteMeSchema = z.object({
    body: z.object({
        password: z.string().min(1).max(128),
    }),
});

export const changePasswordFullSchema = changePwdBody;

export type UpdateMeInput = z.infer<typeof updateMeSchema>['body'];
export type DeleteMeInput = z.infer<typeof deleteMeSchema>['body'];