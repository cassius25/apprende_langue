import { Router } from 'express';
import { Role } from '../../generated/prisma/client';
import { languageController } from './language.controller';
import {
    createLanguageSchema,
    updateLanguageSchema,
    languageIdParamSchema,
    listLanguagesSchema,
} from './language.schemas';
import { validate } from '../../common/middleware/validate';
import { asyncHandler } from '../../common/utils/asyncHandler';
import { authenticate } from '../../common/middleware/authenticate';
import { authorize } from '../../common/middleware/authorize';

const router = Router();
const canManage = [Role.ADMIN, Role.CONTENT_MANAGER];

// Public
router.get('/', validate({ query: listLanguagesSchema }), asyncHandler(languageController.list));
router.get('/:id', validate({ query: languageIdParamSchema }), asyncHandler(languageController.getById));
router.get('/:id/levels', validate({ query: languageIdParamSchema }), asyncHandler(languageController.listLevels));

// Admin / Content Manager
router.post(
    '/',
    authenticate,
    authorize(...canManage),
    validate({ query: createLanguageSchema }),
    asyncHandler(languageController.create),
);

router.patch(
    '/:id',
    authenticate,
    authorize(...canManage),
    validate({ query: updateLanguageSchema }),
    asyncHandler(languageController.update),
);

router.delete(
    '/:id',
    authenticate,
    authorize(...canManage),
    validate({ query: languageIdParamSchema }),
    asyncHandler(languageController.remove),
);

export default router;