import type { Request, Response } from 'express';
import { goalService } from './goal.service';
import type { UpdateGoalInput, UpsertGoalInput } from './goal.schemas';

export const goalController = {
    async list(req: Request, res: Response): Promise<void> {
        const data = await goalService.list(req.user!.id);
        res.status(200).json({ success: true, data });
    },

    async upsert(req: Request, res: Response): Promise<void> {
        const data = await goalService.upsert(req.user!.id, req.body as UpsertGoalInput);
        res.status(200).json({ success: true, data });
    },

    async update(req: Request, res: Response): Promise<void> {
        const data = await goalService.update(req.user!.id, req.params.id, req.body as UpdateGoalInput);
        res.status(200).json({ success: true, data });
    },

    async remove(req: Request, res: Response): Promise<void> {
        await goalService.remove(req.user!.id, req.params.id);
        res.status(204).send();
    },

    async today(req: Request, res: Response): Promise<void> {
        const data = await goalService.getToday(req.user!.id);
        res.status(200).json({ success: true, data });
    },
};