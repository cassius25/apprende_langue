import type { Request, Response } from 'express';
import { languageService } from './language.service';
import type { CreateLanguageInput, UpdateLanguageInput } from './language.schemas';

export const languageController = {
    async list(req: Request, res: Response): Promise<void> {
        const activeOnly = (req.query as { activeOnly?: boolean }).activeOnly ?? true;
        const languages = await languageService.list(activeOnly);
        res.status(200).json({ success: true, data: languages });
    },

    async getById(req: Request, res: Response): Promise<void> {
        const lang = await languageService.getById(req.params.id);
        res.status(200).json({ success: true, data: lang });
    },

    async listLevels(req: Request, res: Response): Promise<void> {
        const levels = await languageService.listLevels(req.params.id);
        res.status(200).json({ success: true, data: levels });
    },

    async create(req: Request, res: Response): Promise<void> {
        const created = await languageService.create(req.body as CreateLanguageInput);
        res.status(201).json({ success: true, data: created });
    },

    async update(req: Request, res: Response): Promise<void> {
        const updated = await languageService.update(req.params.id, req.body as UpdateLanguageInput);
        res.status(200).json({ success: true, data: updated });
    },

    async remove(req: Request, res: Response): Promise<void> {
        await languageService.remove(req.params.id);
        res.status(204).send();
    },
};