import { Prisma } from '../../generated/prisma/client';
import { prisma } from '../../config/prisma';

/**
 * Helper partagé : enregistre de l'activité utilisateur
 * et met à jour XP, niveau, streak, daily activity, badges.
 *
 * Tout est exécuté dans une transaction pour rester cohérent.
 */

export interface ActivityDelta {
    xp?: number;
    minutes?: number;
    wordsLearned?: number;
    wordsReviewed?: number;
    exercisesDone?: number;
    exercisesCorrect?: number;
    /** Marque la journée comme "active" pour le streak (par défaut : true si au moins une action) */
    markActiveDay?: boolean;
}

export interface ActivityResult {
    xpEarned: number;
    totalXp: number;
    userLevel: number;
    streak: {
        currentStreak: number;
        longestStreak: number;
        totalActiveDays: number;
        lastActiveDate: string | null;
    };
    newBadges: { code: string; name: string; icon: string | null }[];
}

/** Renvoie la date "jour" au format UTC YYYY-MM-DD (minuit UTC). */
function todayUtc(): Date {
    const now = new Date();
    return new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
}

function diffDays(a: Date, b: Date): number {
    const MS = 24 * 60 * 60 * 1000;
    return Math.round((a.getTime() - b.getTime()) / MS);
}

/** Formule simple mais stable. Niveau 1 à 0 XP, +1 niveau tous les 200 XP. */
function computeLevel(xp: number): number {
    return Math.max(1, Math.floor(xp / 200) + 1);
}

export async function recordActivity(
    userId: string,
    delta: ActivityDelta,
): Promise<ActivityResult> {
    return prisma.$transaction(async (tx) => {
        const xpEarned = delta.xp ?? 0;

        // 1) User XP + niveau
        const user = await tx.user.findUniqueOrThrow({ where: { id: userId } });
        const totalXp = user.xp + xpEarned;
        const userLevel = computeLevel(totalXp);

        if (xpEarned !== 0 || userLevel !== user.userLevel) {
            await tx.user.update({
                where: { id: userId },
                data: { xp: totalXp, userLevel },
            });
        }

        // 2) DailyActivity (upsert)
        const date = todayUtc();
        await tx.dailyActivity.upsert({
            where: { userId_date: { userId, date } },
            create: {
                userId,
                date,
                minutesLearned: delta.minutes ?? 0,
                wordsLearned: delta.wordsLearned ?? 0,
                wordsReviewed: delta.wordsReviewed ?? 0,
                exercisesDone: delta.exercisesDone ?? 0,
                exercisesCorrect: delta.exercisesCorrect ?? 0,
                xpEarned,
            },
            update: {
                minutesLearned: { increment: delta.minutes ?? 0 },
                wordsLearned: { increment: delta.wordsLearned ?? 0 },
                wordsReviewed: { increment: delta.wordsReviewed ?? 0 },
                exercisesDone: { increment: delta.exercisesDone ?? 0 },
                exercisesCorrect: { increment: delta.exercisesCorrect ?? 0 },
                xpEarned: { increment: xpEarned },
            },
        });

        // 3) Streak (calcul basé sur la date UTC)
        let streak = await tx.streak.findUnique({ where: { userId } });
        if (!streak) {
            streak = await tx.streak.create({ data: { userId } });
        }

        const shouldMark = delta.markActiveDay !== false && (delta.xp !== undefined || delta.minutes);
        let currentStreak = streak.currentStreak;
        let longestStreak = streak.longestStreak;
        let totalActiveDays = streak.totalActiveDays;
        let lastActiveDate = streak.lastActiveDate;

        if (shouldMark) {
            const today = date;
            const last = streak.lastActiveDate;

            if (!last) {
                currentStreak = 1;
                totalActiveDays = 1;
            } else {
                const d = diffDays(today, last);
                if (d === 0) {
                    // même jour → rien
                } else if (d === 1) {
                    currentStreak = streak.currentStreak + 1;
                    totalActiveDays = streak.totalActiveDays + 1;
                } else if (d > 1) {
                    currentStreak = 1;
                    totalActiveDays = streak.totalActiveDays + 1;
                }
                // d < 0 : incohérence (fuseau), on ignore
            }
            lastActiveDate = today;
            if (currentStreak > longestStreak) longestStreak = currentStreak;

            await tx.streak.update({
                where: { userId },
                data: { currentStreak, longestStreak, totalActiveDays, lastActiveDate },
            });
        }

        // 4) Badges (évalués après mise à jour)
        const newBadges = await evaluateBadges(tx, userId, {
            currentStreak,
            totalXp,
        });

        return {
            xpEarned,
            totalXp,
            userLevel,
            streak: {
                currentStreak,
                longestStreak,
                totalActiveDays,
                lastActiveDate: lastActiveDate ? lastActiveDate.toISOString() : null,
            },
            newBadges,
        };
    });
}

interface BadgeContext {
    currentStreak: number;
    totalXp: number;
}

async function evaluateBadges(
    tx: Prisma.TransactionClient,
    userId: string,
    ctx: BadgeContext,
): Promise<{ code: string; name: string; icon: string | null }[]> {
    const allBadges = await tx.badge.findMany();
    const owned = await tx.userBadge.findMany({
        where: { userId },
        select: { badgeId: true },
    });
    const ownedIds = new Set(owned.map((b) => b.badgeId));

    const candidates = allBadges.filter((b) => !ownedIds.has(b.id));
    if (candidates.length === 0) return [];

    const earned: { code: string; name: string; icon: string | null }[] = [];

    for (const badge of candidates) {
        const cond = badge.condition as { type?: string; value?: number } | null;
        if (!cond?.type || typeof cond.value !== 'number') continue;

        let ok = false;
        switch (cond.type) {
            case 'STREAK':
                ok = ctx.currentStreak >= cond.value;
                break;
            case 'LESSON': {
                const count = await tx.userProgress.count({
                    where: { userId, status: 'COMPLETED' },
                });
                ok = count >= cond.value;
                break;
            }
            case 'WORDS': {
                const count = await tx.userVocabulary.count({
                    where: { userId, state: 'MASTERED', deletedAt: null },
                });
                ok = count >= cond.value;
                break;
            }
            case 'EXERCISES': {
                const agg = await tx.dailyActivity.aggregate({
                    where: { userId },
                    _sum: { exercisesCorrect: true },
                });
                ok = (agg._sum.exercisesCorrect ?? 0) >= cond.value;
                break;
            }
            case 'LANGUAGES': {
                const count = await tx.userLanguage.count({ where: { userId, isActive: true } });
                ok = count >= cond.value;
                break;
            }
        }

        if (ok) {
            await tx.userBadge.create({
                data: { userId, badgeId: badge.id },
            });
            earned.push({ code: badge.code, name: badge.name, icon: badge.icon });
        }
    }

    return earned;
}