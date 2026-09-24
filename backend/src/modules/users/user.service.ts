import type { User } from '../../generated/prisma/client';
import { BadRequestError, NotFoundError, UnauthorizedError } from '../../common/errors/HttpErrors';
import { verifyPassword } from '../../common/utils/argon';
import { userRepository } from './user.repository';
import { authRepository } from '../auth/auth.repository';
import { authService } from '../auth/auth.service';
import type { UpdateMeInput, DeleteMeInput } from './user.schemas';
import type { ChangePasswordInput } from '../auth/auth.schemas';
import type { UserProfile } from './user.dto';

function toProfile(user: User): UserProfile {
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
        lastLoginAt: user.lastLoginAt ? user.lastLoginAt.toISOString() : null,
        createdAt: user.createdAt.toISOString(),
        updatedAt: user.updatedAt.toISOString(),
    };
}

export const userService = {
    async getMe(userId: string): Promise<UserProfile> {
        const user = await userRepository.findById(userId);
        if (!user) throw new NotFoundError('User not found');
        return toProfile(user);
    },

    async updateMe(userId: string, input: UpdateMeInput): Promise<UserProfile> {
        const user = await userRepository.findById(userId);
        if (!user) throw new NotFoundError('User not found');

        const updated = await userRepository.update(userId, {
            ...(input.firstName !== undefined ? { firstName: input.firstName } : {}),
            ...(input.lastName !== undefined ? { lastName: input.lastName } : {}),
            ...(input.nativeLanguageId !== undefined
                ? { nativeLanguage: input.nativeLanguageId ? { connect: { id: input.nativeLanguageId } } : { disconnect: true } }
                : {}),
        });
        return toProfile(updated);
    },

    async changePassword(userId: string, input: ChangePasswordInput): Promise<void> {
        await authService.changePassword(userId, input);
    },

    async deleteMe(userId: string, input: DeleteMeInput): Promise<void> {
        const user = await userRepository.findById(userId);
        if (!user) throw new NotFoundError('User not found');

        const ok = await verifyPassword(user.passwordHash, input.password);
        if (!ok) throw new UnauthorizedError('Password is incorrect');

        await userRepository.softDelete(userId);
    },
};

// Empêche l'import circulaire inutilisé
void authRepository;
void BadRequestError;