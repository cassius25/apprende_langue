import { Router } from 'express';
import { authController } from './auth.controller';
import {
    registerSchema,
    loginSchema,
    refreshSchema,
    logoutSchema,
    forgotPasswordSchema,
    resetPasswordSchema,
    verifyEmailSchema,
} from './auth.schemas';
import { validate } from '../../common/middleware/validate';
import { asyncHandler } from '../../common/utils/asyncHandler';
import { authRateLimiter } from '../../common/middleware/rateLimit';
import { authenticate } from '../../common/middleware/authenticate';

const router = Router();

router.post(
    '/register',
    authRateLimiter,
    validate({ query: registerSchema }),
    asyncHandler(authController.register),
);

router.post(
    '/login',
    authRateLimiter,
    validate({ query: loginSchema }),
    asyncHandler(authController.login),
);

router.post(
    '/refresh',
    authRateLimiter,
    validate({ query: refreshSchema }),
    asyncHandler(authController.refresh),
);

router.post(
    '/logout',
    validate({ query: logoutSchema }),
    asyncHandler(authController.logout),
);

router.post(
    '/logout-all',
    authenticate,
    asyncHandler(authController.logoutAll),
);

router.post(
    '/forgot-password',
    authRateLimiter,
    validate({ query: forgotPasswordSchema }),
    asyncHandler(authController.forgotPassword),
);

router.post(
    '/reset-password',
    authRateLimiter,
    validate({ query: resetPasswordSchema }),
    asyncHandler(authController.resetPassword),
);

router.post(
    '/verify-email',
    validate({ query: verifyEmailSchema }),
    asyncHandler(authController.verifyEmail),
);

router.post(
    '/resend-verification',
    authenticate,
    authRateLimiter,
    asyncHandler(authController.resendVerification),
);

export default router;