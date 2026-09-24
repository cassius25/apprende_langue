import { NotFoundError } from '../../common/errors/HttpErrors';
import { recordActivity } from '../../common/utils/engagement';
import { applySrs } from './review.srs';
import { reviewRepository } from './review.repository';
import type {
    ReviewCardDto,
    ReviewResultDto,
    SubmitBatchReviewsResponse,
    SubmitReviewResponse,
    VocabularyStateDto,
} from './review.dto';
import type { TodayReviewsQuery } from './review.schemas';

// XP : 3 XP pour un échec, 5 XP pour un succès — plus bonus selon la qualité
const XP_FAIL = 2;
const XP_SUCCESS_BASE = 5;

function xpForQuality(q: number): number {
    if (q < 3) return XP_FAIL;
    return XP_SUCCESS_BASE + (q - 3); // 5, 6, 7
}

export const reviewService = {
    // ────────────────────────────────────────────────────────
    // File de révision du jour
    // ────────────────────────────────────────────────────────
    async getTodayReviews(userId: string, query: TodayReviewsQuery): Promise<ReviewCardDto[]> {
        const rows = await reviewRepository.findDueReviews(
            userId,
            query.limit ?? 50,
            query.languageId,
            query.includeNew ?? false,
        );

        return rows.map((uv) => ({
            userVocabularyId: uv.id,
            vocabularyId: uv.vocabulary.id,
            word: uv.vocabulary.word,
            phonetic: uv.vocabulary.phonetic,
            audioUrl: uv.vocabulary.audioUrl,
            imageUrl: uv.vocabulary.imageUrl,
            translations: uv.vocabulary.translations.map((t) => ({
                languageCode: t.language.code,
                translation: t.translation,
            })),
            examples: uv.vocabulary.examples.map((e) => ({
                sentence: e.sentence,
                translation: e.translation,
            })),
            state: uv.state as VocabularyStateDto,
            repetitions: uv.repetitions,
            intervalDays: uv.intervalDays,
            easeFactor: uv.easeFactor,
            nextReviewAt: uv.nextReviewAt ? uv.nextReviewAt.toISOString() : null,
        }));
    },

    async countDue(userId: string): Promise<number> {
        return reviewRepository.countDue(userId);
    },

    // ────────────────────────────────────────────────────────
    // Soumission d'une révision (unitaire)
    // ────────────────────────────────────────────────────────
    async submitReview(
        userId: string,
        userVocabularyId: string,
        quality: number,
        responseTimeMs?: number,
    ): Promise<SubmitReviewResponse> {
        const uv = await reviewRepository.findUserVocabularyById(userVocabularyId, userId);
        if (!uv) throw new NotFoundError('Vocabulary not in your review list');

        const previous = {
            state: uv.state as VocabularyStateDto,
            repetitions: uv.repetitions,
            intervalDays: uv.intervalDays,
            easeFactor: uv.easeFactor,
        };

        const srs = applySrs(
            {
                repetitions: uv.repetitions,
                intervalDays: uv.intervalDays,
                easeFactor: uv.easeFactor,
                successRate: uv.successRate,
            },
            quality,
            uv.state,
        );

        // Persiste la session
        await reviewRepository.createSession({
            userId,
            userVocabularyId: uv.id,
            quality,
            responseTimeMs: responseTimeMs ?? null,
        });

        // Met à jour l'état SRS du mot
        await reviewRepository.updateUserVocabulary(uv.id, {
            state: srs.state,
            repetitions: srs.repetitions,
            intervalDays: srs.intervalDays,
            easeFactor: srs.easeFactor,
            successRate: srs.successRate,
            difficulty: srs.difficulty,
            nextReviewAt: srs.nextReviewAt,
            lastReviewedAt: new Date(),
        });

        // XP + activité + streak + badges
        const xp = xpForQuality(quality);
        const activity = await recordActivity(userId, {
            xp,
            wordsReviewed: 1,
            markActiveDay: true,
        });

        const result: ReviewResultDto = {
            userVocabularyId: uv.id,
            quality,
            isCorrect: srs.isCorrect,
            previous,
            current: {
                state: srs.state as VocabularyStateDto,
                repetitions: srs.repetitions,
                intervalDays: srs.intervalDays,
                easeFactor: srs.easeFactor,
                successRate: srs.successRate,
                difficulty: srs.difficulty,
                nextReviewAt: srs.nextReviewAt.toISOString(),
            },
            nextReviewInDays: srs.intervalDays,
        };

        return {
            ...result,
            xpEarned: activity.xpEarned,
            totalXp: activity.totalXp,
            userLevel: activity.userLevel,
            streak: activity.streak,
            newBadges: activity.newBadges,
        };
    },

    // ────────────────────────────────────────────────────────
    // Soumission d'un lot de révisions
    // ────────────────────────────────────────────────────────
    async submitBatchReviews(
        userId: string,
        reviews: { userVocabularyId: string; quality: number; responseTimeMs?: number }[],
    ): Promise<SubmitBatchReviewsResponse> {
        const results: ReviewResultDto[] = [];
        let totalXp = 0;
        let successCount = 0;

        for (const r of reviews) {
            const uv = await reviewRepository.findUserVocabularyById(r.userVocabularyId, userId);
            if (!uv) continue; // on ignore les entrées invalides plutôt que d'échouer tout le batch

            const previous = {
                state: uv.state as VocabularyStateDto,
                repetitions: uv.repetitions,
                intervalDays: uv.intervalDays,
                easeFactor: uv.easeFactor,
            };

            const srs = applySrs(
                {
                    repetitions: uv.repetitions,
                    intervalDays: uv.intervalDays,
                    easeFactor: uv.easeFactor,
                    successRate: uv.successRate,
                },
                r.quality,
                uv.state,
            );

            await reviewRepository.createSession({
                userId,
                userVocabularyId: uv.id,
                quality: r.quality,
                responseTimeMs: r.responseTimeMs ?? null,
            });

            await reviewRepository.updateUserVocabulary(uv.id, {
                state: srs.state,
                repetitions: srs.repetitions,
                intervalDays: srs.intervalDays,
                easeFactor: srs.easeFactor,
                successRate: srs.successRate,
                difficulty: srs.difficulty,
                nextReviewAt: srs.nextReviewAt,
                lastReviewedAt: new Date(),
            });

            totalXp += xpForQuality(r.quality);
            if (srs.isCorrect) successCount++;

            results.push({
                userVocabularyId: uv.id,
                quality: r.quality,
                isCorrect: srs.isCorrect,
                previous,
                current: {
                    state: srs.state as VocabularyStateDto,
                    repetitions: srs.repetitions,
                    intervalDays: srs.intervalDays,
                    easeFactor: srs.easeFactor,
                    successRate: srs.successRate,
                    difficulty: srs.difficulty,
                    nextReviewAt: srs.nextReviewAt.toISOString(),
                },
                nextReviewInDays: srs.intervalDays,
            });
        }

        // Enregistre l'activité en une fois
        const activity = await recordActivity(userId, {
            xp: totalXp,
            wordsReviewed: results.length,
            markActiveDay: true,
        });

        void successCount;

        return {
            results,
            totalXpEarned: activity.xpEarned,
            totalXp: activity.totalXp,
            userLevel: activity.userLevel,
            streak: activity.streak,
            newBadges: activity.newBadges,
        };
    },
};