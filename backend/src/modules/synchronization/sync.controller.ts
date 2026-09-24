import type { Request, Response } from 'express';
import { syncService } from './sync.service';
import type { SyncPushInput } from './sync.schemas';

export const syncController = {
    async push(req: Request, res: Response): Promise<void> {
        const input = req.body as SyncPushInput;
        const result = await syncService.push(req.user!.id, input);
        res.status(200).json({ success: true, data: result });
    },
};