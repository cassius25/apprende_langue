import { Router } from 'express';
import { streakController } from './streak.controller';
import { streakCalendarSchema } from './streak.schemas';
import { validate } from '../../common/middleware/validate';
import { asyncHandler } from '../../common/utils/asyncHandler';
import { authenticate } from '../../common/middleware/authenticate';

const router = Router();
router.use(authenticate);

router.get('/', asyncHandler(streakController.get));
router.get('/calendar', validate({ query: streakCalendarSchema }), asyncHandler(streakController.calendar));

export default router;