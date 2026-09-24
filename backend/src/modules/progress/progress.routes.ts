import { Router } from 'express';
import { progressController } from './progress.controller';
import { languageProgressParamSchema, lessonsProgressSchema } from './progress.schemas';
import { validate } from '../../common/middleware/validate';
import { asyncHandler } from '../../common/utils/asyncHandler';
import { authenticate } from '../../common/middleware/authenticate';

const router = Router();
router.use(authenticate);

router.get('/', asyncHandler(progressController.global));
router.get(
    '/languages/:languageId',
    validate({ query: languageProgressParamSchema }),
    asyncHandler(progressController.byLanguage),
);
router.get('/lessons', validate({ query: lessonsProgressSchema }), asyncHandler(progressController.lessons));

export default router;