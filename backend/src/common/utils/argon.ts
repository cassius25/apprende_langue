import argon2 from 'argon2';
import { env } from '../../config/env';

const options: argon2.Options = {
    type: argon2.argon2id,
    memoryCost: env.ARGON_MEMORY_COST,
    timeCost: env.ARGON_TIME_COST,
    parallelism: env.ARGON_PARALLELISM,
};

export function hashPassword(plain: string): Promise<string> {
    return argon2.hash(plain, options);
}

export async function verifyPassword(hash: string, plain: string): Promise<boolean> {
    try {
        return await argon2.verify(hash, plain);
    } catch {
        return false;
    }
}