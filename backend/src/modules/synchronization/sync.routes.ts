import { Router } from 'express';
import { syncController } from './sync.controller';
import { syncPushSchema } from './sync.schemas';
import { validate } from '../../common/middleware/validate';
import { asyncHandler } from '../../common/utils/asyncHandler';
import { authenticate } from '../../common/middleware/authenticate';
import { syncRateLimiter } from '../../common/middleware/rateLimit';

const router = Router();
router.use(authenticate);

/**
 * Endpoint unique : push + pull incrémental.
 * Rate-limité (60 req/min) car potentiellement lourd.
 */
router.post('/', syncRateLimiter, validate({ query: syncPushSchema }), asyncHandler(syncController.push));

export default router;