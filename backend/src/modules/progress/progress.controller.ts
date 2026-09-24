import type { Request, Response } from 'express';
import { progressService } from './progress.service';
import type { LessonsProgressQuery } from './progress.schemas';

export const progressController = {
    async global(req: Request, res: Response): Promise<void> {
        const result = await progressService.getGlobal(req.user!.id);
        res.status(200).json({ success: true, data: result });
    },

    async byLanguage(req: Request, res: Response): Promise<void> {
        const result = await progressService.getForLanguage(req.user!.id, req.params.languageId);
        res.status(200).json({ success: true, data: result });
    },

    async lessons(req: Request, res: Response): Promise<void> {
        const result = await progressService.listLessons(
            req.user!.id,
            req.query as unknown as LessonsProgressQuery,
        );
        res.status(200).json({ success: true, data: result.data, meta: result.meta });
    },
};