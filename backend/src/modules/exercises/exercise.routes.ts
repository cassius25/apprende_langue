import { Router } from 'express';
import { Role } from '../../generated/prisma/client';
import { exerciseController } from './exercise.controller';
import {
    addOptionSchema,
    createExerciseSchema,
    deleteOptionSchema,
    exerciseIdParamSchema,
    lessonIdParamSchema,
    submitExerciseSchema,
    submitLessonBatchSchema,
    updateExerciseSchema,
    updateOptionSchema,
} from './exercise.schemas';
import { validate } from '../../common/middleware/validate';
import { asyncHandler } from '../../common/utils/asyncHandler';
import { authenticate } from '../../common/middleware/authenticate';
import { authorize } from '../../common/middleware/authorize';

const router = Router();
const canManage = [Role.ADMIN, Role.CONTENT_MANAGER];

router.use(authenticate);

// ─── Étudiant ────────────────────────────────────────────────
router.post(
    '/:id/submit',
    validate({ query: submitExerciseSchema }),
    asyncHandler(exerciseController.submit),
);

// Soumission d'une leçon complète (batch)
router.post(
    '/lessons/:lessonId/submit',
    validate({ query: submitLessonBatchSchema }),
    asyncHandler(exerciseController.submitLessonBatch),
);

// ─── Admin — Exercise CRUD ───────────────────────────────────
router.get(
    '/:id/admin',
    authorize(...canManage),
    validate({ query: exerciseIdParamSchema }),
    asyncHandler(exerciseController.getForAdmin),
);

router.post(
    '/lessons/:lessonId',
    authorize(...canManage),
    validate({ query: createExerciseSchema }),
    asyncHandler(exerciseController.create),
);

router.patch(
    '/:id',
    authorize(...canManage),
    validate({ query: updateExerciseSchema }),
    asyncHandler(exerciseController.update),
);

router.delete(
    '/:id',
    authorize(...canManage),
    validate({ query: exerciseIdParamSchema }),
    asyncHandler(exerciseController.remove),
);

// ─── Admin — Options ─────────────────────────────────────────
router.post(
    '/:id/options',
    authorize(...canManage),
    validate({ query: addOptionSchema }),
    asyncHandler(exerciseController.addOption),
);

router.patch(
    '/:id/options/:optionId',
    authorize(...canManage),
    validate({ query: updateOptionSchema }),
    asyncHandler(exerciseController.updateOption),
);

router.delete(
    '/:id/options/:optionId',
    authorize(...canManage),
    validate({ query: deleteOptionSchema }),
    asyncHandler(exerciseController.removeOption),
);

export default router;