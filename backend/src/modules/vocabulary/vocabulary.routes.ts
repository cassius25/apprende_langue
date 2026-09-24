import { Router } from 'express';
import { Role } from '../../generated/prisma/client';
import { vocabularyController } from './vocabulary.controller';
import {
    createExampleSchema,
    createTranslationSchema,
    createVocabularySchema,
    deleteExampleSchema,
    deleteTranslationSchema,
    dueVocabularySchema,
    favoriteVocabularySchema,
    learnVocabularySchema,
    listMyVocabularySchema,
    listVocabularySchema,
    setStateSchema,
    updateExampleSchema,
    updateTranslationSchema,
    updateVocabularySchema,
    vocabularyIdParamSchema,
} from './vocabulary.schemas';
import { validate } from '../../common/middleware/validate';
import { asyncHandler } from '../../common/utils/asyncHandler';
import { authenticate } from '../../common/middleware/authenticate';
import { authorize } from '../../common/middleware/authorize';

const router = Router();
const canManage = [Role.ADMIN, Role.CONTENT_MANAGER];

router.use(authenticate);

// ─── User (avant /:id pour éviter les collisions de routes) ───
router.get('/me', validate(listMyVocabularySchema), asyncHandler(vocabularyController.listMine));
router.get('/me/favorites', asyncHandler(vocabularyController.listFavorites));
router.get('/me/due', validate(dueVocabularySchema), asyncHandler(vocabularyController.listDue));
router.post('/me/learn', validate(learnVocabularySchema), asyncHandler(vocabularyController.learn));
router.patch(
    '/me/:vocabularyId/favorite',
    validate(favoriteVocabularySchema),
    asyncHandler(vocabularyController.setFavorite),
);
router.patch(
    '/me/:vocabularyId/state',
    validate(setStateSchema),
    asyncHandler(vocabularyController.setState),
);

// ─── Catalogue ────────────────────────────────────────────────
router.get('/', validate(listVocabularySchema), asyncHandler(vocabularyController.listCatalog));
router.get('/:id', validate(vocabularyIdParamSchema), asyncHandler(vocabularyController.getCatalogById));

// ─── Admin — Vocabulary ───────────────────────────────────────
router.post(
    '/',
    authorize(...canManage),
    validate(createVocabularySchema),
    asyncHandler(vocabularyController.create),
);
router.patch(
    '/:id',
    authorize(...canManage),
    validate(updateVocabularySchema),
    asyncHandler(vocabularyController.update),
);
router.delete(
    '/:id',
    authorize(...canManage),
    validate(vocabularyIdParamSchema),
    asyncHandler(vocabularyController.remove),
);

// ─── Admin — Translations ─────────────────────────────────────
router.post(
    '/:id/translations',
    authorize(...canManage),
    validate(createTranslationSchema),
    asyncHandler(vocabularyController.addTranslation),
);
router.patch(
    '/:id/translations/:translationId',
    authorize(...canManage),
    validate(updateTranslationSchema),
    asyncHandler(vocabularyController.updateTranslation),
);
router.delete(
    '/:id/translations/:translationId',
    authorize(...canManage),
    validate(deleteTranslationSchema),
    asyncHandler(vocabularyController.removeTranslation),
);

// ─── Admin — Examples ─────────────────────────────────────────
router.post(
    '/:id/examples',
    authorize(...canManage),
    validate(createExampleSchema),
    asyncHandler(vocabularyController.addExample),
);
router.patch(
    '/:id/examples/:exampleId',
    authorize(...canManage),
    validate(updateExampleSchema),
    asyncHandler(vocabularyController.updateExample),
);
router.delete(
    '/:id/examples/:exampleId',
    authorize(...canManage),
    validate(deleteExampleSchema),
    asyncHandler(vocabularyController.removeExample),
);

export default router;