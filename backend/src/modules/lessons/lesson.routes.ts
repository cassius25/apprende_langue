import { Router } from 'express';
import { Role } from '../../generated/prisma/client';
import { lessonController } from './lesson.controller';
import {
    completeLessonSchema,
    createLessonSchema,
    lessonIdParamSchema,
    updateLessonSchema,
} from './lesson.schemas';
import { validate } from '../../common/middleware/validate';
import { asyncHandler } from '../../common/utils/asyncHandler';
import { authenticate } from '../../common/middleware/authenticate';
import { authorize } from '../../common/middleware/authorize';

const router = Router();
const canManage = [Role.ADMIN, Role.CONTENT_MANAGER];

router.use(authenticate);

router.get('/:id', validate({ query: lessonIdParamSchema }), asyncHandler(lessonController.getById));

router.post(
    '/:id/complete',
    validate({ query: completeLessonSchema }),
    asyncHandler(lessonController.complete),
);

router.post(
    '/modules/:moduleId/lessons',
    authorize(...canManage),
    validate({ query: createLessonSchema }),
    asyncHandler(lessonController.create),
);

router.patch(
    '/:id',
    authorize(...canManage),
    validate({ query: updateLessonSchema }),
    asyncHandler(lessonController.update),
);

router.delete(
    '/:id',
    authorize(...canManage),
    validate({ query: lessonIdParamSchema }),
    asyncHandler(lessonController.remove),
);

export default router;