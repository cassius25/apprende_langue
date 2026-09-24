import { prisma } from '../../config/prisma';
import { statisticsRepository } from './statistics.repository';
import { reviewRepository } from '../reviews/review.repository';
import type {
    ActivityChartDto,
    OverviewStatsDto,
    SkillProgressDto,
    SkillsStatsDto,
} from './statistics.dto';
import type { ActivityStatsQuery, SkillsStatsQuery } from './statistics.schemas';

const XP_PER_LEVEL = 200;

function todayUtc(): Date {
    const now = new Date();
    return new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
}

function daysAgo(n: number): Date {
    const d = todayUtc();
    d.setUTCDate(d.getUTCDate() - n);
    return d;
}

function dayKey(d: Date): string {
    return d.toISOString().slice(0, 10);
}

function safePercent(part: number, total: number): number {
    if (total === 0) return 0;
    return Math.round((part / total) * 1000) / 10;
}

export const statisticsService = {
    // ────────────────────────────────────────────────────────
    // Vue d'ensemble
    // ────────────────────────────────────────────────────────
    async getOverview(userId: string): Promise<OverviewStatsDto> {
        const since7 = daysAgo(7);
        const since30 = daysAgo(30);
        const sinceInfinity = new Date(0);

        const [
            sumAll,
            sum7,
            sum30,
            vocabLearned,
            vocabMastered,
            vocabDueToday,
            lessonsCompleted,
            lessonsTotal,
            user,
            streak,
        ] = await Promise.all([
            statisticsRepository.aggregateActivity(userId, sinceInfinity),
            statisticsRepository.aggregateActivity(userId, since7),
            statisticsRepository.aggregateActivity(userId, since30),
            statisticsRepository.countUserVocabularyTotal(userId),
            statisticsRepository.countUserVocabularyByState(userId, 'MASTERED'),
            reviewRepository.countDue(userId),
            statisticsRepository.countLessonsCompleted(userId),
            statisticsRepository.countLessonsTotal(),
            prisma.user.findUnique({ where: { id: userId }, select: { xp: true, userLevel: true } }),
            prisma.streak.findUnique({ where: { userId } }),
        ]);

        if (!user) {
            throw new Error('User not found');
        }

        const exercisesDone = sumAll._sum.exercisesDone ?? 0;
        const exercisesCorrect = sumAll._sum.exercisesCorrect ?? 0;

        const xpInLevel = user.xp % XP_PER_LEVEL;

        return {
            timeLearnedMinutes: {
                total: sumAll._sum.minutesLearned ?? 0,
                last7Days: sum7._sum.minutesLearned ?? 0,
                last30Days: sum30._sum.minutesLearned ?? 0,
            },
            words: {
                learned: vocabLearned,
                mastered: vocabMastered,
                reviewedTotal: sumAll._sum.wordsReviewed ?? 0,
                dueToday: vocabDueToday,
            },
            exercises: {
                done: exercisesDone,
                correct: exercisesCorrect,
                successRate: safePercent(exercisesCorrect, exercisesDone),
            },
            lessons: {
                completed: lessonsCompleted,
                total: lessonsTotal,
                completionPercent: safePercent(lessonsCompleted, lessonsTotal),
            },
            xp: {
                total: user.xp,
                level: user.userLevel,
                xpInLevel,
                xpToNextLevel: XP_PER_LEVEL - xpInLevel,
            },
            streak: {
                current: streak?.currentStreak ?? 0,
                longest: streak?.longestStreak ?? 0,
                totalActiveDays: streak?.totalActiveDays ?? 0,
            },
        };
    },

    // ────────────────────────────────────────────────────────
    // Activité quotidienne (chart)
    // ────────────────────────────────────────────────────────
    async getActivity(userId: string, query: ActivityStatsQuery): Promise<ActivityChartDto> {
        const days = query.days ?? 30;
        const offset = query.offset ?? 0;

        const to = todayUtc();
        to.setUTCDate(to.getUTCDate() - offset);
        const from = new Date(to);
        from.setUTCDate(from.getUTCDate() - (days - 1));

        const rows = await statisticsRepository.findActivityRange(userId, from, to);
        const byDate = new Map(rows.map((r: { date: Date; }) => [dayKey(r.date), r]));

        const dayList: ActivityChartDto['days'] = [];
        const totals = {
            minutesLearned: 0,
            xpEarned: 0,
            wordsLearned: 0,
            wordsReviewed: 0,
            exercisesDone: 0,
            exercisesCorrect: 0,
        };

        for (let i = 0; i < days; i++) {
            const d = new Date(from);
            d.setUTCDate(d.getUTCDate() + i);
            const key = dayKey(d);
            const r = byDate.get(key);

            const entry = {
                date: key,
                minutesLearned: r?.minutesLearned ?? 0,
                xpEarned: r?.xpEarned ?? 0,
                wordsLearned: r?.wordsLearned ?? 0,
                wordsReviewed: r?.wordsReviewed ?? 0,
                exercisesDone: r?.exercisesDone ?? 0,
                exercisesCorrect: r?.exercisesCorrect ?? 0,
            };
            dayList.push(entry);

            totals.minutesLearned += entry.minutesLearned;
            totals.xpEarned += entry.xpEarned;
            totals.wordsLearned += entry.wordsLearned;
            totals.wordsReviewed += entry.wordsReviewed;
            totals.exercisesDone += entry.exercisesDone;
            totals.exercisesCorrect += entry.exercisesCorrect;
        }

        return { from: dayKey(from), to: dayKey(to), days: dayList, totals };
    },

    // ────────────────────────────────────────────────────────
    // Progression par compétence
    // ────────────────────────────────────────────────────────
    async getSkills(userId: string, query: SkillsStatsQuery): Promise<SkillsStatsDto> {
        const languageId = query.languageId;

        const [
            vocabTotal,
            vocabMastered,
            lessonsCompleted,
            lessonsTotal,
            listeningTotal,
            grammarTotal,
            readingTotal,
            writingTotal,
            exerciseDist,
            pronunciationAttempts,
        ] = await Promise.all([
            statisticsRepository.countUserVocabularyTotal(userId),
            statisticsRepository.countUserVocabularyByState(userId, 'MASTERED'),
            statisticsRepository.countLessonsCompleted(userId, languageId),
            statisticsRepository.countLessonsTotal(languageId),
            statisticsRepository.countListeningExercises(languageId),
            statisticsRepository.countGrammarExercises(languageId),
            statisticsRepository.countReadingExercises(languageId),
            statisticsRepository.countWritingExercises(languageId),
            statisticsRepository.exerciseTypeDistribution(userId, languageId),
            statisticsRepository.countPronunciationAttempts(userId, languageId),
        ]);

        const completedTypes = new Map<string, number>();
        for (const d of exerciseDist) completedTypes.set(d.type, d.count);

        const skills: SkillProgressDto[] = [
            {
                skill: 'VOCABULARY',
                progressPercent: safePercent(vocabMastered, Math.max(1, vocabTotal)),
                metrics: { learned: vocabTotal, mastered: vocabMastered },
            },
            {
                skill: 'GRAMMAR',
                progressPercent: safePercent(
                    completedTypes.get('MULTIPLE_CHOICE') ?? 0,
                    Math.max(1, grammarTotal),
                ),
                metrics: {
                    exercisesInGrammar: grammarTotal,
                    completed: completedTypes.get('MULTIPLE_CHOICE') ?? 0,
                },
            },
            {
                skill: 'LISTENING',
                progressPercent: safePercent(
                    completedTypes.get('LISTENING') ?? 0,
                    Math.max(1, listeningTotal),
                ),
                metrics: {
                    exercisesInListening: listeningTotal,
                    completed: completedTypes.get('LISTENING') ?? 0,
                },
            },
            {
                skill: 'READING',
                progressPercent: safePercent(lessonsCompleted, Math.max(1, lessonsTotal)),
                metrics: {
                    lessonsCompleted,
                    lessonsTotal,
                    readingExercises: readingTotal,
                },
            },
            {
                skill: 'SPEAKING',
                progressPercent: safePercent(pronunciationAttempts, Math.max(1, pronunciationAttempts + 10)),
                metrics: {
                    pronunciationAttempts,
                },
            },
            {
                skill: 'WRITING',
                progressPercent: safePercent(
                    (completedTypes.get('WORD_ORDER') ?? 0) +
                    (completedTypes.get('FILL_IN_THE_BLANK') ?? 0) +
                    (completedTypes.get('TRANSLATION') ?? 0),
                    Math.max(1, writingTotal),
                ),
                metrics: {
                    exercisesInWriting: writingTotal,
                    completed:
                        (completedTypes.get('WORD_ORDER') ?? 0) +
                        (completedTypes.get('FILL_IN_THE_BLANK') ?? 0) +
                        (completedTypes.get('TRANSLATION') ?? 0),
                },
            },
        ];

        return { languageId: languageId ?? null, skills };
    },
};