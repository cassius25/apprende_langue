import { z } from 'zod';

export const streakCalendarSchema = z.object({
    query: z.object({
        /** Nombre de jours en arrière (par défaut 30, max 365). */
        days: z.coerce.number().int().positive().max(365).optional(),
        /** Décalage en jours vers le passé (0 = jusqu'à aujourd'hui). */
        offset: z.coerce.number().int().min(0).max(365).optional(),
    }),
});

export type StreakCalendarQuery = z.infer<typeof streakCalendarSchema>['query'];