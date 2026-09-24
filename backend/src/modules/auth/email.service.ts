import { logger } from '../../config/logger';
import { isProd } from '../../config/env';

/**
 * Service d'email minimaliste.
 * En dev : on log juste le contenu (liens cliquables).
 * En prod : remplacer le corps par un appel réel (SendGrid, Resend, SES, ...)
 * via une variable d'env (SMTP_URL / API_KEY) — hors scope ici.
 */

interface SendArgs {
    to: string;
    subject: string;
    html: string;
    text?: string;
}

async function send({ to, subject, html, text }: SendArgs): Promise<void> {
    if (isProd) {
        // TODO: intégrer un provider réel en production.
        logger.warn({ to, subject }, 'email: no provider configured in production');
        return;
    }
    logger.info(
        { to, subject, text: text ?? html.replace(/<[^>]+>/g, ' ').slice(0, 500) },
        '📧 email (dev)',
    );
}

export const emailService = {
    sendVerificationEmail(to: string, firstName: string, token: string): Promise<void> {
        const link = `langapp://verify-email?token=${encodeURIComponent(token)}`;
        return send({
            to,
            subject: 'Vérifiez votre adresse email',
            html: `<p>Bonjour ${firstName},</p>
             <p>Confirmez votre compte en cliquant ici : <a href="${link}">${link}</a></p>
             <p>Ce lien expire dans 24 heures.</p>`,
            text: `Vérification: ${link}`,
        });
    },

    sendPasswordResetEmail(to: string, firstName: string, token: string): Promise<void> {
        const link = `langapp://reset-password?token=${encodeURIComponent(token)}`;
        return send({
            to,
            subject: 'Réinitialisation du mot de passe',
            html: `<p>Bonjour ${firstName},</p>
             <p>Réinitialisez votre mot de passe : <a href="${link}">${link}</a></p>
             <p>Ce lien expire dans 1 heure.</p>`,
            text: `Réinitialisation: ${link}`,
        });
    },
};