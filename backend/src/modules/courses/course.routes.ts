import { Router } from 'express';
import { Role } from '../../generated/prisma/client';
import { courseController } from './course.controller';
import {
    createCourseSchema,
    createModuleSchema,
    courseIdParamSchema,
    listCoursesSchema,
    updateCourseSchema,
} from './course.schemas';
import { validate } from '../../common/middleware/validate';
import { asyncHandler } from '../../common/utils/asyncHandler';
import { authenticate } from '../../common/middleware/authenticate';
import { authorize } from '../../common/middleware/authorize';

const router = Router();
const canManage = [Role.ADMIN, Role.CONTENT_MANAGER];

router.use(authenticate);

router.get('/', validate({ query: listCoursesSchema }), asyncHandler(courseController.list));
router.get('/:id', validate({ query: courseIdParamSchema }), asyncHandler(courseController.getById));

router.post(
    '/',
    authorize(...canManage),
    validate({ query: createCourseSchema }),
    asyncHandler(courseController.create),
);

router.patch(
    '/:id',
    authorize(...canManage),
    validate({ query: updateCourseSchema }),
    asyncHandler(courseController.update),
);

router.delete(
    '/:id',
    authorize(...canManage),
    validate({ query: courseIdParamSchema }),
    asyncHandler(courseController.remove),
);

router.post(
    '/:id/modules',
    authorize(...canManage),
    validate({ query: createModuleSchema }),
    asyncHandler(courseController.addModule),
);

export default router;