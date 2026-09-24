import type { Request, Response } from 'express';
import { vocabularyService } from './vocabulary.service';
import type {
    CreateExampleInput,
    CreateTranslationInput,
    CreateVocabularyInput,
    DueVocabularyQuery,
    FavoriteVocabularyInput,
    LearnVocabularyInput,
    ListMyVocabularyQuery,
    ListVocabularyQuery,
    SetStateInput,
    UpdateExampleInput,
    UpdateTranslationInput,
    UpdateVocabularyInput,
} from './vocabulary.schemas';

export const vocabularyController = {
    // ─── Catalogue ────────────────────────────────────────────
    async listCatalog(req: Request, res: Response): Promise<void> {
        const result = await vocabularyService.listCatalog(req.query as unknown as ListVocabularyQuery);
        res.status(200).json({ success: true, data: result.data, meta: result.meta });
    },

    async getCatalogById(req: Request, res: Response): Promise<void> {
        const v = await vocabularyService.getCatalogById(req.params.id);
        res.status(200).json({ success: true, data: v });
    },

    async create(req: Request, res: Response): Promise<void> {
        const created = await vocabularyService.create(req.body as CreateVocabularyInput);
        res.status(201).json({ success: true, data: created });
    },

    async update(req: Request, res: Response): Promise<void> {
        const updated = await vocabularyService.update(req.params.id, req.body as UpdateVocabularyInput);
        res.status(200).json({ success: true, data: updated });
    },

    async remove(req: Request, res: Response): Promise<void> {
        await vocabularyService.remove(req.params.id);
        res.status(204).send();
    },

    // ─── Translations ─────────────────────────────────────────
    async addTranslation(req: Request, res: Response): Promise<void> {
        const t = await vocabularyService.addTranslation(
            req.params.id,
            req.body as CreateTranslationInput,
        );
        res.status(201).json({ success: true, data: t });
    },

    async updateTranslation(req: Request, res: Response): Promise<void> {
        const t = await vocabularyService.updateTranslation(
            req.params.id,
            req.params.translationId,
            req.body as UpdateTranslationInput,
        );
        res.status(200).json({ success: true, data: t });
    },

    async removeTranslation(req: Request, res: Response): Promise<void> {
        await vocabularyService.removeTranslation(req.params.id, req.params.translationId);
        res.status(204).send();
    },

    // ─── Examples ─────────────────────────────────────────────
    async addExample(req: Request, res: Response): Promise<void> {
        const e = await vocabularyService.addExample(req.params.id, req.body as CreateExampleInput);
        res.status(201).json({ success: true, data: e });
    },

    async updateExample(req: Request, res: Response): Promise<void> {
        const e = await vocabularyService.updateExample(
            req.params.id,
            req.params.exampleId,
            req.body as UpdateExampleInput,
        );
        res.status(200).json({ success: true, data: e });
    },

    async removeExample(req: Request, res: Response): Promise<void> {
        await vocabularyService.removeExample(req.params.id, req.params.exampleId);
        res.status(204).send();
    },

    // ─── User ─────────────────────────────────────────────────
    async listMine(req: Request, res: Response): Promise<void> {
        const result = await vocabularyService.listMine(
            req.user!.id,
            req.query as unknown as ListMyVocabularyQuery,
        );
        res.status(200).json({ success: true, data: result.data, meta: result.meta });
    },

    async listFavorites(req: Request, res: Response): Promise<void> {
        const data = await vocabularyService.listFavorites(req.user!.id);
        res.status(200).json({ success: true, data });
    },

    async listDue(req: Request, res: Response): Promise<void> {
        const data = await vocabularyService.listDue(
            req.user!.id,
            req.query as unknown as DueVocabularyQuery,
        );
        res.status(200).json({ success: true, data });
    },

    async learn(req: Request, res: Response): Promise<void> {
        const { vocabularyId } = req.body as LearnVocabularyInput;
        const uv = await vocabularyService.learn(req.user!.id, vocabularyId);
        res.status(201).json({ success: true, data: uv });
    },

    async setFavorite(req: Request, res: Response): Promise<void> {
        const { isFavorite } = req.body as FavoriteVocabularyInput;
        const uv = await vocabularyService.setFavorite(
            req.user!.id,
            req.params.vocabularyId,
            isFavorite,
        );
        res.status(200).json({ success: true, data: uv });
    },

    async setState(req: Request, res: Response): Promise<void> {
        const { state } = req.body as SetStateInput;
        const uv = await vocabularyService.setState(
            req.user!.id,
            req.params.vocabularyId,
            state,
        );
        res.status(200).json({ success: true, data: uv });
    },
};