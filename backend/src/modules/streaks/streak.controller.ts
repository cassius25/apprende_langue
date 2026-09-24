import type { Request, Response } from 'express';
import { streakService } from './streak.service';
import type { StreakCalendarQuery } from './streak.schemas';

export const streakController = {
    async get(req: Request, res: Response): Promise<void> {
        const result = await streakService.get(req.user!.id);
        res.status(200).json({ success: true, data: result });
    },

    async calendar(req: Request, res: Response): Promise<void> {
        const q = req.query as unknown as StreakCalendarQuery;
        const result = await streakService.getCalendar(req.user!.id, q.days ?? 30, q.offset ?? 0);
        res.status(200).json({ success: true, data: result });
    },
};