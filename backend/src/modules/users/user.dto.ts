import type { Role } from '../../generated/prisma/client';

export interface UserProfile {
    id: string;
    email: string;
    firstName: string;
    lastName: string;
    role: Role;
    emailVerified: boolean;
    nativeLanguageId: string | null;
    xp: number;
    userLevel: number;
    lastLoginAt: string | null;
    createdAt: string;
    updatedAt: string;
}