import type { Prisma, User } from '../../generated/prisma/client';
import { prisma } from '../../config/prisma';

export const authRepository = {
    findUserByEmail(email: string): Promise<User | null> {
        return prisma.user.findFirst({
            where: { email, deletedAt: null },
        });
    },

    findUserById(id: string): Promise<User | null> {
        return prisma.user.findFirst({ where: { id, deletedAt: null } });
    },

    createUser(data: Prisma.UserCreateInput): Promise<User> {
        return prisma.user.create({ data });
    },

    updateUser(id: string, data: Prisma.UserUpdateInput): Promise<User> {
        return prisma.user.update({ where: { id }, data });
    },

    // ─── Refresh tokens ────────────────────────────────────
    createRefreshToken(data: Prisma.RefreshTokenUncheckedCreateInput) {
        return prisma.refreshToken.create({ data });
    },

    findRefreshTokenByHash(tokenHash: string) {
        return prisma.refreshToken.findUnique({ where: { tokenHash } });
    },

    revokeRefreshToken(id: string) {
        return prisma.refreshToken.update({
            where: { id },
            data: { revokedAt: new Date() },
        });
    },

    revokeAllUserRefreshTokens(userId: string) {
        return prisma.refreshToken.updateMany({
            where: { userId, revokedAt: null },
            data: { revokedAt: new Date() },
        });
    },

    // ─── Transactions ──────────────────────────────────────
    async transaction<T>(fn: (tx: Prisma.TransactionClient) => Promise<T>): Promise<T> {
        return prisma.$transaction(fn);
    },
};