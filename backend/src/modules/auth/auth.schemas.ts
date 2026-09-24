import { z } from 'zod';

const passwordSchema = z
    .string()
    .min(8, 'Password must be at least 8 characters')
    .max(128, 'Password is too long')
    .regex(/[A-Z]/, 'Password must contain an uppercase letter')
    .regex(/[a-z]/, 'Password must contain a lowercase letter')
    .regex(/[0-9]/, 'Password must contain a digit');

export const registerSchema = z.object({
    body: z.object({
        firstName: z.string().min(1).max(80),
        lastName: z.string().min(1).max(80),
        email: z.string().email().max(255).toLowerCase().trim(),
        password: passwordSchema,
        nativeLanguageId: z.string().uuid().optional(),
        learningLanguageId: z.string().uuid().optional(),
        acceptTerms: z.boolean().optional(),
    }),
});

export const loginSchema = z.object({
    body: z.object({
        email: z.string().email().toLowerCase().trim(),
        password: z.string().min(1).max(128),
        userAgent: z.string().max(255).optional(),
    }),
});

export const refreshSchema = z.object({
    body: z.object({
        refreshToken: z.string().min(20).max(512),
    }),
});

export const logoutSchema = z.object({
    body: z.object({
        refreshToken: z.string().min(20).max(512),
    }),
});

export const forgotPasswordSchema = z.object({
    body: z.object({
        email: z.string().email().toLowerCase().trim(),
    }),
});

export const resetPasswordSchema = z.object({
    body: z.object({
        token: z.string().min(20).max(512),
        newPassword: passwordSchema,
    }),
});

export const verifyEmailSchema = z.object({
    body: z.object({
        token: z.string().min(20).max(512),
    }),
});

export const changePasswordSchema = z.object({
    body: z.object({
        currentPassword: z.string().min(1).max(128),
        newPassword: passwordSchema,
    }),
});

export type RegisterInput = z.infer<typeof registerSchema>['body'];
export type LoginInput = z.infer<typeof loginSchema>['body'];
export type RefreshInput = z.infer<typeof refreshSchema>['body'];
export type LogoutInput = z.infer<typeof logoutSchema>['body'];
export type ForgotPasswordInput = z.infer<typeof forgotPasswordSchema>['body'];
export type ResetPasswordInput = z.infer<typeof resetPasswordSchema>['body'];
export type VerifyEmailInput = z.infer<typeof verifyEmailSchema>['body'];
export type ChangePasswordInput = z.infer<typeof changePasswordSchema>['body'];