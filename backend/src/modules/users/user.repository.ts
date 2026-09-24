import type { Prisma, User } from '../../generated/prisma/client';
import { prisma } from '../../config/prisma';

export const userRepository = {
    findById(id: string): Promise<User | null> {
        return prisma.user.findFirst({ where: { id, deletedAt: null } });
    },

    update(id: string, data: Prisma.UserUpdateInput): Promise<User> {
        return prisma.user.update({ where: { id }, data });
    },

    /** Soft delete + anonymisation + révocation des sessions. */
    async softDelete(id: string): Promise<void> {
        await prisma.$transaction(async (tx) => {
            await tx.refreshToken.updateMany({
                where: { userId: id, revokedAt: null },
                data: { revokedAt: new Date() },
            });
            await tx.user.update({
                where: { id },
                data: {
                    deletedAt: new Date(),
                    email: `deleted+${id}@langapp.local`,
                    firstName: 'Deleted',
                    lastName: 'User',
                },
            });
        });
    },
};