import { NotFoundError } from '../../common/errors/HttpErrors';
import { goalRepository } from './goal.repository';
import type { GoalDto, TodayGoalProgressDto } from './goal.dto';
import type { GoalTypeDto, UpdateGoalInput, UpsertGoalInput } from './goal.schemas';
import type { DailyGoal } from '../../generated/prisma/client';

function todayUtc(): Date {
    const now = new Date();
    return new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
}

function toDto(g: DailyGoal): GoalDto {
    return {
        id: g.id,
        type: g.type as 'MINUTES' | 'WORDS',
        target: g.target,
        isActive: g.isActive,
        createdAt: g.createdAt.toISOString(),
        updatedAt: g.updatedAt.toISOString(),
    };
}

export const goalService = {
    async list(userId: string): Promise<GoalDto[]> {
        const goals = await goalRepository.findByUser(userId);
        return goals.map(toDto);
    },

    /**
     * Upsert : un seul objectif actif par (user, type).
     * Si un objectif du même type existe, on le met à jour au lieu d'en créer un nouveau.
     */
    async upsert(userId: string, input: UpsertGoalInput): Promise<GoalDto> {
        const existing = await goalRepository.findByUserAndType(userId, input.type);
        if (existing) {
            const updated = await goalRepository.update(existing.id, {
                target: input.target,
                isActive: input.isActive ?? true,
            });
            return toDto(updated);
        }
        const created = await goalRepository.create({
            userId,
            type: input.type,
            target: input.target,
            isActive: input.isActive ?? true,
        });
        return toDto(created);
    },

    async update(userId: string, id: string, input: UpdateGoalInput): Promise<GoalDto> {
        const goal = await goalRepository.findById(id);
        if (!goal || goal.userId !== userId) throw new NotFoundError('Goal not found');
        const updated = await goalRepository.update(id, input);
        return toDto(updated);
    },

    async remove(userId: string, id: string): Promise<void> {
        const goal = await goalRepository.findById(id);
        if (!goal || goal.userId !== userId) throw new NotFoundError('Goal not found');
        await goalRepository.delete(id);
    },

    // ────────────────────────────────────────────────────────
    // Objectif du jour (dashboard)
    // ────────────────────────────────────────────────────────
    async getToday(userId: string): Promise<TodayGoalProgressDto> {
        const goals = await goalRepository.findByUser(userId);
        const goal = goals.find((g) => g.type === 'MINUTES') ?? goals[0] ?? null;

        const activity = await goalRepository.getTodayActivity(userId, todayUtc());

        const minutesLearned = activity?.minutesLearned ?? 0;
        const wordsLearned = activity?.wordsLearned ?? 0;

        if (!goal) {
            return {
                goal: null,
                current: 0,
                target: 0,
                progressPercent: 0,
                achieved: false,
                minutesLearned,
                wordsLearned,
            };
        }

        const current = goal.type === 'MINUTES' ? minutesLearned : wordsLearned;
        const progressPercent =
            goal.target > 0 ? Math.min(100, Math.round((current / goal.target) * 1000) / 10) : 0;

        return {
            goal: toDto(goal),
            current,
            target: goal.target,
            progressPercent,
            achieved: current >= goal.target,
            minutesLearned,
            wordsLearned,
        };
    },

    /** Garde-fou : normalise un type côté admin. */
    normalizeType(t: string): GoalTypeDto {
        return t === 'WORDS' ? 'WORDS' : 'MINUTES';
    },
};