import type { Request, Response } from 'express';
import { userService } from './user.service';
import type { UpdateMeInput, DeleteMeInput } from './user.schemas';
import type { ChangePasswordInput } from '../auth/auth.schemas';

export const userController = {
    async getMe(req: Request, res: Response): Promise<void> {
        const profile = await userService.getMe(req.user!.id);
        res.status(200).json({ success: true, data: profile });
    },

    async updateMe(req: Request, res: Response): Promise<void> {
        const profile = await userService.updateMe(req.user!.id, req.body as UpdateMeInput);
        res.status(200).json({ success: true, data: profile });
    },

    async changePassword(req: Request, res: Response): Promise<void> {
        await userService.changePassword(req.user!.id, req.body as ChangePasswordInput);
        res.status(204).send();
    },

    async deleteMe(req: Request, res: Response): Promise<void> {
        await userService.deleteMe(req.user!.id, req.body as DeleteMeInput);
        res.status(204).send();
    },
};