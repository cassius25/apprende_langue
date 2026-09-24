import { z } from 'zod';

export const activityStatsSchema = z.object({
    query: z.object({
        days: z.coerce.number().int().positive().max(365).optional(),
        offset: z.coerce.number().int().min(0).max(365).optional(),
    }),
});

export const skillsStatsSchema = z.object({
    query: z.object({
        languageId: z.string().uuid().optional(),
    }),
});

export type ActivityStatsQuery = z.infer<typeof activityStatsSchema>['query'];
export type SkillsStatsQuery = z.infer<typeof skillsStatsSchema>['query'];