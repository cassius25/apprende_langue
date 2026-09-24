import { Router } from 'express';
import { goalController } from './goal.controller';
import { goalIdParamSchema, updateGoalSchema, upsertGoalSchema } from './goal.schemas';
import { validate } from '../../common/middleware/validate';
import { asyncHandler } from '../../common/utils/asyncHandler';
import { authenticate } from '../../common/middleware/authenticate';

const router = Router();
router.use(authenticate);

router.get('/', asyncHandler(goalController.list));
router.get('/today', asyncHandler(goalController.today));
router.post('/', validate({ query: upsertGoalSchema }), asyncHandler(goalController.upsert));
router.patch('/:id', validate({ query: updateGoalSchema }), asyncHandler(goalController.update));
router.delete('/:id', validate({ query: goalIdParamSchema }), asyncHandler(goalController.remove));

export default router;