import { z } from 'zod';

const goalTypes = ['MINUTES', 'WORDS'] as const;

export const upsertGoalSchema = z.object({
    body: z.object({
        type: z.enum(goalTypes),
        target: z.number().int().positive().max(1000),
        isActive: z.boolean().optional(),
    }),
});

export const goalIdParamSchema = z.object({
    params: z.object({ id: z.string().uuid() }),
});

export const updateGoalSchema = z.object({
    params: z.object({ id: z.string().uuid() }),
    body: z
        .object({
            target: z.number().int().positive().max(1000).optional(),
            isActive: z.boolean().optional(),
        })
        .refine((b) => Object.keys(b).length > 0, { message: 'At least one field is required' }),
});

export type UpsertGoalInput = z.infer<typeof upsertGoalSchema>['body'];
export type UpdateGoalInput = z.infer<typeof updateGoalSchema>['body'];
export type GoalTypeDto = (typeof goalTypes)[number];