import type { Request, Response } from 'express';
import { statisticsService } from './statistics.service';
import type { ActivityStatsQuery, SkillsStatsQuery } from './statistics.schemas';

export const statisticsController = {
    async overview(req: Request, res: Response): Promise<void> {
        const data = await statisticsService.getOverview(req.user!.id);
        res.status(200).json({ success: true, data });
    },

    async activity(req: Request, res: Response): Promise<void> {
        const data = await statisticsService.getActivity(
            req.user!.id,
            req.query as unknown as ActivityStatsQuery,
        );
        res.status(200).json({ success: true, data });
    },

    async skills(req: Request, res: Response): Promise<void> {
        const data = await statisticsService.getSkills(
            req.user!.id,
            req.query as unknown as SkillsStatsQuery,
        );
        res.status(200).json({ success: true, data });
    },
};