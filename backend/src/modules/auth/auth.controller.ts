import type { Request, Response } from 'express';
import { authService } from './auth.service';
import type {
    RegisterInput,
    LoginInput,
    RefreshInput,
    LogoutInput,
    ForgotPasswordInput,
    ResetPasswordInput,
    VerifyEmailInput,
} from './auth.schemas';

export const authController = {
    async register(req: Request, res: Response): Promise<void> {
        const result = await authService.register(req.body as RegisterInput, req);
        res.status(201).json({ success: true, data: result });
    },

    async login(req: Request, res: Response): Promise<void> {
        const result = await authService.login(req.body as LoginInput, req);
        res.status(200).json({ success: true, data: result });
    },

    async refresh(req: Request, res: Response): Promise<void> {
        const { refreshToken } = req.body as RefreshInput;
        const tokens = await authService.refresh(refreshToken, req);
        res.status(200).json({ success: true, data: { tokens } });
    },

    async logout(req: Request, res: Response): Promise<void> {
        const { refreshToken } = req.body as LogoutInput;
        await authService.logout(refreshToken);
        res.status(204).send();
    },

    async logoutAll(req: Request, res: Response): Promise<void> {
        await authService.logoutAll(req.user!.id);
        res.status(204).send();
    },

    async forgotPassword(req: Request, res: Response): Promise<void> {
        await authService.forgotPassword(req.body as ForgotPasswordInput);
        res.status(202).json({
            success: true,
            data: { message: 'If the email exists, a reset link has been sent.' },
        });
    },

    async resetPassword(req: Request, res: Response): Promise<void> {
        await authService.resetPassword(req.body as ResetPasswordInput);
        res.status(204).send();
    },

    async verifyEmail(req: Request, res: Response): Promise<void> {
        await authService.verifyEmail(req.body as VerifyEmailInput);
        res.status(200).json({ success: true, data: { message: 'Email verified' } });
    },

    async resendVerification(req: Request, res: Response): Promise<void> {
        await authService.resendVerificationEmail(req.user!.id);
        res.status(202).json({ success: true, data: { message: 'Verification email sent' } });
    },
};