import type { Request, Response } from 'express';
import { lessonService } from './lesson.service';
import type { CompleteLessonInput, CreateLessonInput, UpdateLessonInput } from './lesson.schemas';

export const lessonController = {
    async getById(req: Request, res: Response): Promise<void> {
        const lesson = await lessonService.getById(req.params.id, req.user?.id);
        res.status(200).json({ success: true, data: lesson });
    },

    async complete(req: Request, res: Response): Promise<void> {
        const result = await lessonService.complete(
            req.params.id,
            req.user!.id,
            req.body as CompleteLessonInput,
        );
        res.status(200).json({ success: true, data: result });
    },

    async create(req: Request, res: Response): Promise<void> {
        const created = await lessonService.create(req.params.moduleId, req.body as CreateLessonInput);
        res.status(201).json({ success: true, data: created });
    },

    async update(req: Request, res: Response): Promise<void> {
        const updated = await lessonService.update(req.params.id, req.body as UpdateLessonInput);
        res.status(200).json({ success: true, data: updated });
    },

    async remove(req: Request, res: Response): Promise<void> {
        await lessonService.remove(req.params.id);
        res.status(204).send();
    },
};