import { Router } from 'express';
import { userController } from './user.controller';
import { updateMeSchema, deleteMeSchema } from './user.schemas';
import { changePasswordFullSchema } from '../auth/auth.schemas';
import { validate } from '../../common/middleware/validate';
import { authenticate } from '../../common/middleware/authenticate';
import { asyncHandler } from '../../common/utils/asyncHandler';

const router = Router();

router.use(authenticate);

router.get('/me', asyncHandler(userController.getMe));

router.patch(
    '/me',
    validate(updateMeSchema),
    asyncHandler(userController.updateMe),
);

router.post(
    '/me/change-password',
    validate({ body: changePasswordFullSchema.shape.body }),
    asyncHandler(userController.changePassword),
);

router.delete(
    '/me',
    validate(deleteMeSchema),
    asyncHandler(userController.deleteMe),
);

export default router;