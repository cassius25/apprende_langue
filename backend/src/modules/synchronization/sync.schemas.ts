import { z } from 'zod';

const syncableEntities = [
    'user_vocabulary',
    'user_progress',
    'daily_goals',
    'user_languages',
] as const;

const readOnlyEntities = [
    'streaks',
    'user_badges',
    'daily_activity',
] as const;

export type SyncableEntity = (typeof syncableEntities)[number];
export type ReadOnlyEntity = (typeof readOnlyEntities)[number];

export const syncOperationSchema = z.object({
    id: z.string().uuid(),
    entity: z.enum(syncableEntities),
    entityId: z.string().uuid(),
    op: z.enum(['UPSERT', 'DELETE']),
    payload: z.unknown().optional(),
    clientTimestamp: z.string().datetime(),
});

export const syncPushSchema = z.object({
    body: z.object({
        /** Dernier curseur serveur connu du client (ISO). Omis = première sync. */
        since: z.string().datetime().optional(),
        operations: z.array(syncOperationSchema).max(500).default([]),
    }),
});

export type SyncOperationInput = z.infer<typeof syncOperationSchema>;
export type SyncPushInput = z.infer<typeof syncPushSchema>['body'];