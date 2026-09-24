import type { Request, Response } from 'express';
import { exerciseService } from './exercise.service';
import type {
    AddOptionInput,
    CreateExerciseInput,
    SubmitExerciseInput,
    SubmitLessonBatchInput,
    UpdateExerciseInput,
    UpdateOptionInput,
} from './exercise.schemas';

export const exerciseController = {
    // ─── Étudiant ─────────────────────────────────────────────
    async submit(req: Request, res: Response): Promise<void> {
        const { answer, responseTimeMs } = req.body as SubmitExerciseInput;
        const result = await exerciseService.submit(req.params.id, req.user!.id, answer, responseTimeMs);
        res.status(200).json({ success: true, data: result });
    },

    async submitLessonBatch(req: Request, res: Response): Promise<void> {
        const { answers } = req.body as SubmitLessonBatchInput;
        const result = await exerciseService.submitLessonBatch(req.params.lessonId, req.user!.id, answers);
        res.status(200).json({ success: true, data: result });
    },

    // ─── Admin ────────────────────────────────────────────────
    async create(req: Request, res: Response): Promise<void> {
        const created = await exerciseService.create(req.params.lessonId, req.body as CreateExerciseInput);
        res.status(201).json({ success: true, data: created });
    },

    async update(req: Request, res: Response): Promise<void> {
        const updated = await exerciseService.update(req.params.id, req.body as UpdateExerciseInput);
        res.status(200).json({ success: true, data: updated });
    },

    async remove(req: Request, res: Response): Promise<void> {
        await exerciseService.remove(req.params.id);
        res.status(204).send();
    },

    async getForAdmin(req: Request, res: Response): Promise<void> {
        const ex = await exerciseService.getForAdmin(req.params.id);
        res.status(200).json({ success: true, data: ex });
    },

    async addOption(req: Request, res: Response): Promise<void> {
        const ex = await exerciseService.addOption(req.params.id, req.body as AddOptionInput);
        res.status(201).json({ success: true, data: ex });
    },

    async updateOption(req: Request, res: Response): Promise<void> {
        const ex = await exerciseService.updateOption(
            req.params.id,
            req.params.optionId,
            req.body as UpdateOptionInput,
        );
        res.status(200).json({ success: true, data: ex });
    },

    async removeOption(req: Request, res: Response): Promise<void> {
        await exerciseService.removeOption(req.params.id, req.params.optionId);
        res.status(204).send();
    },
};