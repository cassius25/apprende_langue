import type { Request, Response } from 'express';
import { reviewService } from './review.service';
import type {
    SubmitBatchReviewsInput,
    SubmitReviewInput,
    TodayReviewsQuery,
} from './review.schemas';

export const reviewController = {
    async today(req: Request, res: Response): Promise<void> {
        const cards = await reviewService.getTodayReviews(
            req.user!.id,
            req.query as unknown as TodayReviewsQuery,
        );
        res.status(200).json({ success: true, data: cards });
    },

    async countDue(req: Request, res: Response): Promise<void> {
        const count = await reviewService.countDue(req.user!.id);
        res.status(200).json({ success: true, data: { dueCount: count } });
    },

    async submit(req: Request, res: Response): Promise<void> {
        const { userVocabularyId, quality, responseTimeMs } = req.body as SubmitReviewInput;
        const result = await reviewService.submitReview(
            req.user!.id,
            userVocabularyId,
            quality,
            responseTimeMs,
        );
        res.status(200).json({ success: true, data: result });
    },

    async submitBatch(req: Request, res: Response): Promise<void> {
        const { reviews } = req.body as SubmitBatchReviewsInput;
        const result = await reviewService.submitBatchReviews(req.user!.id, reviews);
        res.status(200).json({ success: true, data: result });
    },
};