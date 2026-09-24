import { Router } from 'express';
import { statisticsController } from './statistics.controller';
import { activityStatsSchema, skillsStatsSchema } from './statistics.schemas';
import { validate } from '../../common/middleware/validate';
import { asyncHandler } from '../../common/utils/asyncHandler';
import { authenticate } from '../../common/middleware/authenticate';

const router = Router();
router.use(authenticate);

router.get('/', asyncHandler(statisticsController.overview));
router.get(
    '/activity',
    validate({ query: activityStatsSchema }),
    asyncHandler(statisticsController.activity),
);
router.get(
    '/skills',
    validate({ query: skillsStatsSchema }),
    asyncHandler(statisticsController.skills),
);

export default router;