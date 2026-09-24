import { Router } from 'express';
import { reviewController } from './review.controller';
import {
    submitBatchReviewsSchema,
    submitReviewSchema,
    todayReviewsSchema,
} from './review.schemas';
import { validate } from '../../common/middleware/validate';
import { asyncHandler } from '../../common/utils/asyncHandler';
import { authenticate } from '../../common/middleware/authenticate';

const router = Router();
router.use(authenticate);

router.get('/today', validate({ query: todayReviewsSchema }), asyncHandler(reviewController.today));
router.get('/due-count', asyncHandler(reviewController.countDue));
router.post('/', validate({ query: submitReviewSchema }), asyncHandler(reviewController.submit));
router.post('/batch', validate({ query: submitBatchReviewsSchema }), asyncHandler(reviewController.submitBatch));

export default router;