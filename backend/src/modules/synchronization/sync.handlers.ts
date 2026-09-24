import { BadRequestError } from '../../common/errors/HttpErrors';
import type { SyncOperationInput, SyncableEntity } from './sync.schemas';
import { syncRepository } from './sync.repository';

// ─────────────────────────────────────────────────────────────
// Résultat d'un handler
// ─────────────────────────────────────────────────────────────
export interface HandlerOutcome {
    applied: boolean;
    reason?: 'CONFLICT' | 'NOT_FOUND' | 'VALIDATION_ERROR' | 'INTERNAL_ERROR';
    message?: string;
}

type Handler = (userId: string, op: SyncOperationInput) => Promise<HandlerOutcome>;

// ─────────────────────────────────────────────────────────────
// Helpers de validation du payload
// ─────────────────────────────────────────────────────────────
function asRecord(payload: unknown): Record<string, unknown> {
    if (typeof payload !== 'object' || payload === null || Array.isArray(payload)) {
        throw new BadRequestError('payload must be an object');
    }
    return payload as Record<string, unknown>;
}

function str(v: unknown, field: string, optional = false): string | null {
    if (v === undefined || v === null) {
        if (optional) return null;
        throw new BadRequestError(`${field} is required`);
    }
    if (typeof v !== 'string') throw new BadRequestError(`${field} must be a string`);
    return v;
}

function num(v: unknown, field: string, fallback = 0): number {
    if (v === undefined || v === null) return fallback;
    if (typeof v !== 'number' || !Number.isFinite(v)) {
        throw new BadRequestError(`${field} must be a number`);
    }
    return v;
}

function bool(v: unknown, field: string, fallback = false): boolean {
    if (v === undefined || v === null) return fallback;
    if (typeof v !== 'boolean') throw new BadRequestError(`${field} must be a boolean`);
    return v;
}

function isoOrNull(v: unknown, field: string): Date | null {
    if (v === undefined || v === null) return null;
    if (typeof v !== 'string') throw new BadRequestError(`${field} must be an ISO string or null`);
    const d = new Date(v);
    if (Number.isNaN(d.getTime())) throw new BadRequestError(`${field} is not a valid ISO date`);
    return d;
}

/** Vrai si le serveur est plus récent que le client (conflit → serveur gagne). */
function serverWins(serverUpdatedAt: Date, clientTimestamp: Date): boolean {
    return serverUpdatedAt.getTime() > clientTimestamp.getTime();
}

// ─────────────────────────────────────────────────────────────
// user_vocabulary
// ─────────────────────────────────────────────────────────────
const userVocabularyHandler: Handler = async (userId, op) => {
    const clientTs = new Date(op.clientTimestamp);

    if (op.op === 'DELETE') {
        const existing = await syncRepository.findUserVocabularyByNaturalKey(userId, op.entityId);
        if (!existing) return { applied: true }; // idempotent : déjà absent
        if (existing.deletedAt) return { applied: true }; // déjà supprimé
        if (serverWins(existing.updatedAt, clientTs)) {
            return { applied: false, reason: 'CONFLICT', message: 'Server version is newer' };
        }
        await syncRepository.softDeleteUserVocabulary(userId, op.entityId);
        return { applied: true };
    }

    const p = asRecord(op.payload);
    const vocabularyId = op.entityId;

    const vocabExists = await syncRepository.countVocabularyById(vocabularyId);
    if (!vocabExists) return { applied: false, reason: 'NOT_FOUND', message: 'Vocabulary not found' };

    const state = str(p.state, 'state') as
        | 'NEW'
        | 'LEARNING'
        | 'REVIEW'
        | 'MASTERED'
        | null;
    if (!state || !['NEW', 'LEARNING', 'REVIEW', 'MASTERED'].includes(state)) {
        return { applied: false, reason: 'VALIDATION_ERROR', message: 'Invalid state' };
    }

    const existing = await syncRepository.findUserVocabularyByNaturalKey(userId, vocabularyId);
    if (existing && serverWins(existing.updatedAt, clientTs)) {
        return { applied: false, reason: 'CONFLICT', message: 'Server version is newer' };
    }

    await syncRepository.upsertUserVocabulary(userId, vocabularyId, {
        state,
        isFavorite: bool(p.isFavorite, 'isFavorite', false),
        repetitions: Math.max(0, Math.floor(num(p.repetitions, 'repetitions', 0))),
        intervalDays: Math.max(0, Math.floor(num(p.intervalDays, 'intervalDays', 0))),
        easeFactor: Math.min(3.0, Math.max(1.3, num(p.easeFactor, 'easeFactor', 2.5))),
        successRate: Math.min(1, Math.max(0, num(p.successRate, 'successRate', 0))),
        difficulty: Math.min(1, Math.max(0, num(p.difficulty, 'difficulty', 0))),
        nextReviewAt: isoOrNull(p.nextReviewAt, 'nextReviewAt'),
        lastReviewedAt: isoOrNull(p.lastReviewedAt, 'lastReviewedAt'),
        deletedAt: null, // résurrection si l'entité était soft-deleted côté serveur
    });

    return { applied: true };
};

// ─────────────────────────────────────────────────────────────
// user_progress
// ─────────────────────────────────────────────────────────────
const userProgressHandler: Handler = async (userId, op) => {
    if (op.op === 'DELETE') {
        // La progression de leçon n'est pas supprimable côté client — on l'ignore
        return { applied: true };
    }

    const p = asRecord(op.payload);
    const lessonId = op.entityId;

    const lessonExists = await syncRepository.countLessonById(lessonId);
    if (!lessonExists) return { applied: false, reason: 'NOT_FOUND', message: 'Lesson not found' };

    const status = str(p.status, 'status') as
        | 'NOT_STARTED'
        | 'IN_PROGRESS'
        | 'COMPLETED'
        | null;
    if (!status || !['NOT_STARTED', 'IN_PROGRESS', 'COMPLETED'].includes(status)) {
        return { applied: false, reason: 'VALIDATION_ERROR', message: 'Invalid status' };
    }

    const clientTs = new Date(op.clientTimestamp);
    const existing = await syncRepository.findUserProgressByNaturalKey(userId, lessonId);
    if (existing && serverWins(existing.updatedAt, clientTs)) {
        // Exception : si le serveur est IN_PROGRESS et le client COMPLETED, on accepte
        // (le client a fini la leçon offline). Sinon conflit standard.
        const serverCompleted = existing.status === 'COMPLETED';
        const clientCompleted = status === 'COMPLETED';
        if (!(clientCompleted && !serverCompleted)) {
            return { applied: false, reason: 'CONFLICT', message: 'Server version is newer' };
        }
    }

    const score = Math.min(100, Math.max(0, Math.floor(num(p.score, 'score', 0))));
    const timeSpentSec = Math.max(0, Math.floor(num(p.timeSpentSec, 'timeSpentSec', 0)));
    const completedAt = isoOrNull(p.completedAt, 'completedAt');

    await syncRepository.upsertUserProgress(userId, lessonId, {
        status,
        score,
        timeSpentSec,
        completedAt: status === 'COMPLETED' ? completedAt ?? new Date() : completedAt,
    });

    return { applied: true };
};

// ─────────────────────────────────────────────────────────────
// daily_goals
// ─────────────────────────────────────────────────────────────
const dailyGoalHandler: Handler = async (userId, op) => {
    if (op.op === 'DELETE') {
        const type = str((op.payload as Record<string, unknown>)?.type, 'type', true) as
            | 'MINUTES'
            | 'WORDS'
            | null;
        if (!type) return { applied: false, reason: 'VALIDATION_ERROR', message: 'type is required' };
        const existing = await syncRepository.findDailyGoalByNaturalKey(userId, type);
        if (!existing) return { applied: true };
        // Pas de delete client pour les objectifs : on désactive
        await syncRepository.upsertDailyGoal(userId, type, { isActive: false, target: existing.target });
        return { applied: true };
    }

    const p = asRecord(op.payload);
    const type = str(p.type, 'type') as 'MINUTES' | 'WORDS' | null;
    if (!type || !['MINUTES', 'WORDS'].includes(type)) {
        return { applied: false, reason: 'VALIDATION_ERROR', message: 'Invalid type' };
    }

    const target = Math.min(1000, Math.max(1, Math.floor(num(p.target, 'target', 10))));
    const isActive = bool(p.isActive, 'isActive', true);

    const clientTs = new Date(op.clientTimestamp);
    const existing = await syncRepository.findDailyGoalByNaturalKey(userId, type);
    if (existing && serverWins(existing.updatedAt, clientTs)) {
        return { applied: false, reason: 'CONFLICT', message: 'Server version is newer' };
    }

    await syncRepository.upsertDailyGoal(userId, type, { target, isActive });
    return { applied: true };
};

// ─────────────────────────────────────────────────────────────
// user_languages
// ─────────────────────────────────────────────────────────────
const userLanguageHandler: Handler = async (userId, op) => {
    const languageId = op.entityId;

    const langExists = await syncRepository.countLanguageById(languageId);
    if (!langExists) return { applied: false, reason: 'NOT_FOUND', message: 'Language not found' };

    if (op.op === 'DELETE') {
        const existing = await syncRepository.findUserLanguageByNaturalKey(userId, languageId);
        if (!existing) return { applied: true };
        await syncRepository.upsertUserLanguage(userId, languageId, {
            levelId: existing.levelId,
            progressPercent: existing.progressPercent,
            isActive: false,
        });
        return { applied: true };
    }

    const p = asRecord(op.payload);
    const levelIdRaw = str(p.levelId, 'levelId', true);
    if (levelIdRaw) {
        const level = await syncRepository.findLevelById(levelIdRaw);
        if (!level) return { applied: false, reason: 'NOT_FOUND', message: 'Level not found' };
    }

    const clientTs = new Date(op.clientTimestamp);
    const existing = await syncRepository.findUserLanguageByNaturalKey(userId, languageId);
    if (existing && serverWins(existing.updatedAt, clientTs)) {
        return { applied: false, reason: 'CONFLICT', message: 'Server version is newer' };
    }

    await syncRepository.upsertUserLanguage(userId, languageId, {
        levelId: levelIdRaw,
        isActive: bool(p.isActive, 'isActive', true),
        progressPercent: existing?.progressPercent ?? 0,
    });

    return { applied: true };
};

// ─────────────────────────────────────────────────────────────
// Dispatch
// ─────────────────────────────────────────────────────────────
const HANDLERS: Record<SyncableEntity, Handler> = {
    user_vocabulary: userVocabularyHandler,
    user_progress: userProgressHandler,
    daily_goals: dailyGoalHandler,
    user_languages: userLanguageHandler,
};

export function getHandler(entity: SyncableEntity): Handler {
    return HANDLERS[entity];
}