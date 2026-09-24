import type { User } from '../../generated/prisma/client';
import type { Request } from 'express';
import { prisma } from '../../config/prisma';
import { logger } from '../../config/logger';
import { ConflictError, NotFoundError, UnauthorizedError, BadRequestError } from '../../common/errors/HttpErrors';
import { hashPassword, verifyPassword } from '../../common/utils/argon';
import { addHours, generateOpaqueToken, sha256 } from '../../common/utils/crypto';
import { authRepository } from './auth.repository';
import { tokenService } from './token.service';
import { emailService } from './email.service';
import type {
    RegisterInput,
    LoginInput,
    ForgotPasswordInput,
    ResetPasswordInput,
    VerifyEmailInput,
    ChangePasswordInput,
} from './auth.schemas';
import type { AuthResponse, AuthTokens, PublicUser } from './auth.dto';

function toPublicUser(user: User): PublicUser {
    return {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
        emailVerified: user.emailVerified,
        nativeLanguageId: user.nativeLanguageId,
        xp: user.xp,
        userLevel: user.userLevel,
        createdAt: user.createdAt.toISOString(),
    };
}

export const authService = {
    // ────────────────────────────────────────────────────────
    // REGISTER
    // ────────────────────────────────────────────────────────
    async register(input: RegisterInput, req: Request): Promise<AuthResponse> {
        const existing = await authRepository.findUserByEmail(input.email);
        if (existing) throw new ConflictError('Email already registered');

        const passwordHash = await hashPassword(input.password);
        const verificationToken = generateOpaqueToken(32);

        const user = await authRepository.transaction(async (tx) => {
            const created = await tx.user.create({
                data: {
                    email: input.email,
                    passwordHash,
                    firstName: input.firstName,
                    lastName: input.lastName,
                    nativeLanguageId: input.nativeLanguageId ?? null,
                    emailVerified: false,
                    emailVerificationToken: sha256(verificationToken),
                },
            });

            // Ajoute la langue d'apprentissage par défaut si fournie
            if (input.learningLanguageId) {
                await tx.userLanguage.create({
                    data: {
                        userId: created.id,
                        languageId: input.learningLanguageId,
                        isActive: true,
                    },
                });
            }

            // Crée le streak initial + goals par défaut
            await tx.streak.create({ data: { userId: created.id } });
            await tx.dailyGoal.create({
                data: { userId: created.id, type: 'MINUTES', target: 10, isActive: true },
            });

            return created;
        });

        // Email asynchrone (non bloquant)
        void emailService.sendVerificationEmail(user.email, user.firstName, verificationToken);

        const tokens = await tokenService.buildAuthTokens(user, req);
        return { user: toPublicUser(user), tokens };
    },

    // ────────────────────────────────────────────────────────
    // LOGIN
    // ────────────────────────────────────────────────────────
    async login(input: LoginInput, req: Request): Promise<AuthResponse> {
        const user = await authRepository.findUserByEmail(input.email);

        // Constant-time: on hash même si user inconnu
        const dummyHash =
            '$argon2id$v=19$m=19456,t=2,p=1$AAAAAAAAAAAAAAAAAAAAAA$AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
        const ok = user
            ? await verifyPassword(user.passwordHash, input.password)
            : await verifyPassword(dummyHash, input.password).then(() => false);

        if (!user || !ok) throw new UnauthorizedError('Invalid email or password');

        await authRepository.updateUser(user.id, { lastLoginAt: new Date() });

        const tokens = await tokenService.buildAuthTokens(user, req);
        return { user: toPublicUser(user), tokens };
    },

    // ────────────────────────────────────────────────────────
    // REFRESH (rotation + reuse detection)
    // ────────────────────────────────────────────────────────
    async refresh(rawRefresh: string, req: Request): Promise<AuthTokens> {
        const record = await tokenService.verifyRefreshToken(rawRefresh);

        const user = await authRepository.findUserById(record.userId);
        if (!user) throw new UnauthorizedError('User no longer exists');

        // Rotation : révoque l'ancien et émet un nouveau
        await authRepository.revokeRefreshToken(record.id);
        return tokenService.buildAuthTokens(user, req);
    },

    // ────────────────────────────────────────────────────────
    // LOGOUT
    // ────────────────────────────────────────────────────────
    async logout(rawRefresh: string): Promise<void> {
        const tokenHash = sha256(rawRefresh);
        const record = await authRepository.findRefreshTokenByHash(tokenHash);
        if (!record || record.revokedAt) return; // idempotent
        await authRepository.revokeRefreshToken(record.id);
    },

    async logoutAll(userId: string): Promise<void> {
        await authRepository.revokeAllUserRefreshTokens(userId);
    },

    // ────────────────────────────────────────────────────────
    // VERIFY EMAIL
    // ────────────────────────────────────────────────────────
    async verifyEmail(input: VerifyEmailInput): Promise<void> {
        const tokenHash = sha256(input.token);
        const user = await prisma.user.findFirst({
            where: { emailVerificationToken: tokenHash, deletedAt: null },
        });
        if (!user) throw new BadRequestError('Invalid or expired verification token');

        await authRepository.updateUser(user.id, {
            emailVerified: true,
            emailVerificationToken: null,
        });
    },

    async resendVerificationEmail(userId: string): Promise<void> {
        const user = await authRepository.findUserById(userId);
        if (!user) throw new NotFoundError('User not found');
        if (user.emailVerified) throw new BadRequestError('Email already verified');

        const token = generateOpaqueToken(32);
        await authRepository.updateUser(user.id, {
            emailVerificationToken: sha256(token),
        });
        void emailService.sendVerificationEmail(user.email, user.firstName, token);
    },

    // ────────────────────────────────────────────────────────
    // FORGOT / RESET PASSWORD
    // ────────────────────────────────────────────────────────
    async forgotPassword(input: ForgotPasswordInput): Promise<void> {
        const user = await authRepository.findUserByEmail(input.email);
        // Réponse identique que l'email existe ou non (anti-enumeration)
        if (!user) return;

        const token = generateOpaqueToken(32);
        await authRepository.updateUser(user.id, {
            passwordResetToken: sha256(token),
            passwordResetExpires: addHours(1),
        });
        void emailService.sendPasswordResetEmail(user.email, user.firstName, token);
    },

    async resetPassword(input: ResetPasswordInput): Promise<void> {
        const tokenHash = sha256(input.token);
        const user = await prisma.user.findFirst({
            where: { passwordResetToken: tokenHash, deletedAt: null },
        });
        if (!user) throw new BadRequestError('Invalid or expired reset token');
        if (!user.passwordResetExpires || user.passwordResetExpires.getTime() < Date.now()) {
            throw new BadRequestError('Reset token expired');
        }

        const passwordHash = await hashPassword(input.newPassword);
        await authRepository.transaction(async (tx) => {
            await tx.user.update({
                where: { id: user.id },
                data: {
                    passwordHash,
                    passwordResetToken: null,
                    passwordResetExpires: null,
                },
            });
            // Sécurité : révoque toutes les sessions
            await tx.refreshToken.updateMany({
                where: { userId: user.id, revokedAt: null },
                data: { revokedAt: new Date() },
            });
        });
    },

    // ────────────────────────────────────────────────────────
    // CHANGE PASSWORD (utilisateur authentifié)
    // ────────────────────────────────────────────────────────
    async changePassword(userId: string, input: ChangePasswordInput): Promise<void> {
        const user = await authRepository.findUserById(userId);
        if (!user) throw new UnauthorizedError();

        const ok = await verifyPassword(user.passwordHash, input.currentPassword);
        if (!ok) throw new UnauthorizedError('Current password is incorrect');

        const passwordHash = await hashPassword(input.newPassword);
        await authRepository.transaction(async (tx) => {
            await tx.user.update({ where: { id: userId }, data: { passwordHash } });
            await tx.refreshToken.updateMany({
                where: { userId, revokedAt: null },
                data: { revokedAt: new Date() },
            });
        });
        logger.info({ userId }, 'Password changed — all sessions revoked');
    },
};