import { randomBytes, createHash } from 'node:crypto';

/** Génère un token opaque URL-safe (par défaut 48 octets ≈ 64 chars). */
export function generateOpaqueToken(bytes = 48): string {
    return randomBytes(bytes).toString('base64url');
}

/** Hash SHA-256 (hex) — utilisé pour stocker refresh / reset / verify tokens. */
export function sha256(value: string): string {
    return createHash('sha256').update(value).digest('hex');
}

/** Ajoute N jours/ms à maintenant. */
export function addDays(days: number): Date {
    return new Date(Date.now() + days * 24 * 60 * 60 * 1000);
}

export function addHours(hours: number): Date {
    return new Date(Date.now() + hours * 60 * 60 * 1000);
}

export function addMinutes(minutes: number): Date {
    return new Date(Date.now() + minutes * 60 * 1000);
}