import { logger } from '../../config/logger';
import { syncRepository } from './sync.repository';
import { getHandler } from './sync.handlers';
import type { SyncOperationInput, SyncPushInput } from './sync.schemas';
import type {
    DailyActivityChangeDto,
    DailyGoalChangeDto,
    FailedOperationDto,
    StreakChangeDto,
    SyncChangesDto,
    SyncPushResponseDto,
    UserBadgeChangeDto,
    UserLanguageChangeDto,
    UserProgressChangeDto,
    UserVocabularyChangeDto,
} from './sync.dto';

const DEFAULT_INITIAL_WINDOW_MS = 30 * 24 * 60 * 60 * 1000;

// Helper pour convertir Date | null | undefined → string | null
const iso = (d: Date | null | undefined): string | null =>
    d ? d.toISOString() : null;

// Extraire processOperation pour éviter les problèmes de `this`
async function processOperation(
    userId: string,
    op: SyncOperationInput,
): Promise<
    | 'DUPLICATE'
    | 'APPLIED'
    | { reason: FailedOperationDto['reason']; message: string }
> {
    const already = await syncRepository.findOperationById(userId, op.id);
    if (already) return 'DUPLICATE';

    await syncRepository.createOperation({
        id: op.id,
        userId,
        entity: op.entity,
        entityId: op.entityId,
        op: op.op,
        payload: (op.payload ?? {}) as object,
        status: 'PENDING',
        clientTimestamp: new Date(op.clientTimestamp),
    });

    try {
        const handler = getHandler(op.entity);
        const outcome = await handler(userId, op);

        if (outcome.applied) {
            await syncRepository.updateOperationStatus(op.id, 'SYNCED');
            return 'APPLIED';
        }

        await syncRepository.updateOperationStatus(
            op.id,
            'FAILED',
            outcome.message ?? outcome.reason ?? 'Unknown',
        );

        return {
            reason: outcome.reason ?? 'INTERNAL_ERROR',
            message: outcome.message ?? 'Operation failed',
        };
    } catch (err) {
        const message = err instanceof Error ? err.message : 'Unknown error';
        logger.error(
            { userId, opId: op.id, entity: op.entity, err },
            'sync: operation failed',
        );
        await syncRepository.updateOperationStatus(op.id, 'FAILED', message);
        return { reason: 'INTERNAL_ERROR', message };
    }
}

export const syncService = {
    async push(userId: string, input: SyncPushInput): Promise<SyncPushResponseDto> {
        const startedAt = Date.now();
        const applied: string[] = [];
        const failed: FailedOperationDto[] = [];

        // ─── 1) Phase de push ────────────────────────────────────
        for (const op of input.operations) {
            const outcome = await processOperation(userId, op);
            if (outcome === 'DUPLICATE') continue;
            if (outcome === 'APPLIED') applied.push(op.id);
            else {
                failed.push({
                    id: op.id,
                    reason: outcome.reason,
                    message: outcome.message,
                });
            }
        }

        // ─── 2) Phase de pull ────────────────────────────────────
        const serverTime = new Date();
        const since = input.since
            ? new Date(input.since)
            : new Date(serverTime.getTime() - DEFAULT_INITIAL_WINDOW_MS);

        const changes = await this.collectChanges(userId, since);
        const changesCount =
            changes.user_vocabulary.length +
            changes.user_progress.length +
            changes.daily_goals.length +
            changes.user_languages.length +
            changes.streaks.length +
            changes.user_badges.length +
            changes.daily_activity.length;

        logger.info(
            {
                userId,
                pushed: input.operations.length,
                applied: applied.length,
                failed: failed.length,
                pulled: changesCount,
                durationMs: Date.now() - startedAt,
            },
            'sync:push',
        );

        return {
            serverTime: serverTime.toISOString(),
            applied,
            failed,
            changes,
            changesCount,
        };
    },

    async collectChanges(userId: string, since: Date): Promise<SyncChangesDto> {
        const [
            userVocabulary,
            userProgress,
            dailyGoals,
            userLanguages,
            streak,
            userBadges,
            dailyActivity,
        ] = await Promise.all([
            syncRepository.findUserVocabularySince(userId, since),
            syncRepository.findUserProgressSince(userId, since),
            syncRepository.findDailyGoalsSince(userId, since),
            syncRepository.findUserLanguagesSince(userId, since),
            syncRepository.findStreak(userId),
            syncRepository.findUserBadgesSince(userId, since),
            syncRepository.findDailyActivitySince(userId, since),
        ]);

        // Types inférés depuis Prisma — plus d'annotations manuelles
        const changes: SyncChangesDto = {
            user_vocabulary: userVocabulary.map(
                (r): UserVocabularyChangeDto => ({
                    id: r.id,
                    userId: r.userId,
                    vocabularyId: r.vocabularyId,
                    state: r.state as UserVocabularyChangeDto['state'],
                    isFavorite: r.isFavorite,
                    repetitions: r.repetitions,
                    intervalDays: r.intervalDays,
                    easeFactor: r.easeFactor,
                    successRate: r.successRate,
                    difficulty: r.difficulty,
                    nextReviewAt: iso(r.nextReviewAt),
                    lastReviewedAt: iso(r.lastReviewedAt),
                    createdAt: r.createdAt.toISOString(),
                    updatedAt: r.updatedAt.toISOString(),
                    deletedAt: iso(r.deletedAt),
                }),
            ),
            user_progress: userProgress.map(
                (r): UserProgressChangeDto => ({
                    id: r.id,
                    userId: r.userId,
                    lessonId: r.lessonId,
                    status: r.status as UserProgressChangeDto['status'],
                    score: r.score,
                    timeSpentSec: r.timeSpentSec,
                    completedAt: iso(r.completedAt),
                    createdAt: r.createdAt.toISOString(),
                    updatedAt: r.updatedAt.toISOString(),
                }),
            ),
            daily_goals: dailyGoals.map(
                (r): DailyGoalChangeDto => ({
                    id: r.id,
                    userId: r.userId,
                    type: r.type as DailyGoalChangeDto['type'],
                    target: r.target,
                    isActive: r.isActive,
                    createdAt: r.createdAt.toISOString(),
                    updatedAt: r.updatedAt.toISOString(),
                }),
            ),
            user_languages: userLanguages.map(
                (r): UserLanguageChangeDto => ({
                    id: r.id,
                    userId: r.userId,
                    languageId: r.languageId,
                    levelId: r.levelId,
                    isActive: r.isActive,
                    progressPercent: r.progressPercent,
                    startedAt: r.startedAt.toISOString(),
                    createdAt: r.createdAt.toISOString(),
                    updatedAt: r.updatedAt.toISOString(),
                }),
            ),
            streaks: streak
                ? [
                    {
                        id: streak.id,
                        userId: streak.userId,
                        currentStreak: streak.currentStreak,
                        longestStreak: streak.longestStreak,
                        totalActiveDays: streak.totalActiveDays,
                        lastActiveDate: iso(streak.lastActiveDate),
                        updatedAt: streak.updatedAt.toISOString(),
                    } satisfies StreakChangeDto,
                ]
                : [],
            user_badges: userBadges.map(
                (r): UserBadgeChangeDto => ({
                    id: r.id,
                    userId: r.userId,
                    badgeId: r.badgeId,
                    earnedAt: r.earnedAt.toISOString(),
                }),
            ),
            daily_activity: dailyActivity.map(
                (r): DailyActivityChangeDto => ({
                    id: r.id,
                    userId: r.userId,
                    date: r.date.toISOString(),
                    minutesLearned: r.minutesLearned,
                    wordsLearned: r.wordsLearned,
                    wordsReviewed: r.wordsReviewed,
                    exercisesDone: r.exercisesDone,
                    exercisesCorrect: r.exercisesCorrect,
                    xpEarned: r.xpEarned,
                    updatedAt: r.updatedAt.toISOString(),
                }),
            ),
        };

        return changes;
    },
};