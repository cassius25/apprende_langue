import { ConflictError, NotFoundError } from '../../common/errors/HttpErrors';
import { buildPaginationMeta, normalizePagination } from '../../common/utils/pagination';
import {
    vocabularyRepository,
    type UserVocabularyWithRelations,
    type VocabularyWithRelations,
} from './vocabulary.repository';
import type {
    CreateExampleInput,
    CreateTranslationInput,
    CreateVocabularyInput,
    DueVocabularyQuery,
    ListMyVocabularyQuery,
    ListVocabularyQuery,
    UpdateExampleInput,
    UpdateTranslationInput,
    UpdateVocabularyInput,
    VocabularyState,
} from './vocabulary.schemas';
import type {
    DueVocabularyDto,
    ExampleDto,
    TranslationDto,
    UserVocabularyDto,
    VocabularyCatalogDto,
} from './vocabulary.dto';

// ─────────────────────────────────────────────────────────────
// Mappers
// ─────────────────────────────────────────────────────────────
function mapTranslations(v: VocabularyWithRelations): TranslationDto[] {
    return v.translations.map((t: { id: any; languageId: any; language: { code: any; name: any; }; translation: any; }) => ({
        id: t.id,
        languageId: t.languageId,
        languageCode: t.language.code,
        languageName: t.language.name,
        translation: t.translation,
    }));
}

function mapExamples(v: VocabularyWithRelations): ExampleDto[] {
    return v.examples.map((e: { id: any; sentence: any; translation: any; audioUrl: any; order: any; }) => ({
        id: e.id,
        sentence: e.sentence,
        translation: e.translation,
        audioUrl: e.audioUrl,
        order: e.order,
    }));
}

function toCatalogDto(v: VocabularyWithRelations): VocabularyCatalogDto {
    return {
        id: v.id,
        word: v.word,
        phonetic: v.phonetic,
        audioUrl: v.audioUrl,
        imageUrl: v.imageUrl,
        category: v.category,
        partOfSpeech: v.partOfSpeech,
        language: {
            id: v.language.id,
            code: v.language.code,
            name: v.language.name,
            flagEmoji: v.language.flagEmoji,
        },
        level: { id: v.level.id, code: v.level.code, name: v.level.name },
        translations: mapTranslations(v),
        examples: mapExamples(v),
    };
}

function toUserDto(uv: UserVocabularyWithRelations): UserVocabularyDto {
    const v = uv.vocabulary;
    return {
        id: uv.id,
        vocabularyId: v.id,
        word: v.word,
        phonetic: v.phonetic,
        audioUrl: v.audioUrl,
        imageUrl: v.imageUrl,
        category: v.category,
        partOfSpeech: v.partOfSpeech,
        language: {
            id: v.language.id,
            code: v.language.code,
            name: v.language.name,
            flagEmoji: v.language.flagEmoji,
        },
        level: { id: v.level.id, code: v.level.code, name: v.level.name },
        translations: mapTranslations(v),
        examples: mapExamples(v),
        state: uv.state as UserVocabularyDto['state'],
        isFavorite: uv.isFavorite,
        repetitions: uv.repetitions,
        intervalDays: uv.intervalDays,
        easeFactor: uv.easeFactor,
        successRate: uv.successRate,
        nextReviewAt: uv.nextReviewAt ? uv.nextReviewAt.toISOString() : null,
        lastReviewedAt: uv.lastReviewedAt ? uv.lastReviewedAt.toISOString() : null,
        createdAt: uv.createdAt.toISOString(),
    };
}

function toDueDto(uv: UserVocabularyWithRelations): DueVocabularyDto {
    const v = uv.vocabulary;
    return {
        userVocabularyId: uv.id,
        vocabularyId: v.id,
        word: v.word,
        phonetic: v.phonetic,
        audioUrl: v.audioUrl,
        imageUrl: v.imageUrl,
        translations: mapTranslations(v),
        state: uv.state as DueVocabularyDto['state'],
        nextReviewAt: uv.nextReviewAt ? uv.nextReviewAt.toISOString() : null,
        repetitions: uv.repetitions,
    };
}

// ─────────────────────────────────────────────────────────────
// Service
// ─────────────────────────────────────────────────────────────
export const vocabularyService = {
    // ─── Catalogue ────────────────────────────────────────────
    async listCatalog(query: ListVocabularyQuery) {
        const { page, limit, skip, take } = normalizePagination(query);
        const [rows, total] = await vocabularyRepository.findCatalog(query, { skip, take });
        return {
            data: rows.map(toCatalogDto),
            meta: buildPaginationMeta(page, limit, total),
        };
    },

    async getCatalogById(id: string): Promise<VocabularyCatalogDto> {
        const v = await vocabularyRepository.findCatalogById(id);
        if (!v) throw new NotFoundError('Vocabulary not found');
        return toCatalogDto(v);
    },

    async create(input: CreateVocabularyInput): Promise<VocabularyCatalogDto> {
        const created = await vocabularyRepository.create({
            languageId: input.languageId,
            levelId: input.levelId,
            word: input.word,
            phonetic: input.phonetic ?? null,
            audioUrl: input.audioUrl ?? null,
            imageUrl: input.imageUrl ?? null,
            category: input.category ?? null,
            partOfSpeech: input.partOfSpeech ?? null,
        });
        return this.getCatalogById(created.id);
    },

    async update(id: string, input: UpdateVocabularyInput): Promise<VocabularyCatalogDto> {
        const existing = await vocabularyRepository.findCatalogById(id);
        if (!existing) throw new NotFoundError('Vocabulary not found');
        await vocabularyRepository.update(id, input);
        return this.getCatalogById(id);
    },

    async remove(id: string): Promise<void> {
        const existing = await vocabularyRepository.findCatalogById(id);
        if (!existing) throw new NotFoundError('Vocabulary not found');
        await vocabularyRepository.softDelete(id);
    },

    // ─── Translations ─────────────────────────────────────────
    async addTranslation(vocabularyId: string, input: CreateTranslationInput): Promise<TranslationDto> {
        const vocab = await vocabularyRepository.findCatalogById(vocabularyId);
        if (!vocab) throw new NotFoundError('Vocabulary not found');

        const existing = await vocabularyRepository.findTranslation(vocabularyId, input.languageId);
        if (existing) throw new ConflictError('Translation already exists for this language');

        const created = await vocabularyRepository.createTranslation({
            vocabularyId,
            languageId: input.languageId,
            translation: input.translation,
        });

        const refreshed = await vocabularyRepository.findCatalogById(vocabularyId);
        const t = refreshed!.translations.find((x: { id: any; }) => x.id === created.id)!;
        return {
            id: t.id,
            languageId: t.languageId,
            languageCode: t.language.code,
            languageName: t.language.name,
            translation: t.translation,
        };
    },

    async updateTranslation(
        vocabularyId: string,
        translationId: string,
        input: UpdateTranslationInput,
    ): Promise<TranslationDto> {
        const vocab = await vocabularyRepository.findCatalogById(vocabularyId);
        if (!vocab) throw new NotFoundError('Vocabulary not found');

        const row = await vocabularyRepository.findTranslationById(translationId);
        if (!row || row.vocabularyId !== vocabularyId) throw new NotFoundError('Translation not found');

        const updated = await vocabularyRepository.updateTranslation(translationId, input.translation);
        const language = vocab.translations.find((t: { id: string; }) => t.id === translationId)!.language;
        return {
            id: updated.id,
            languageId: updated.languageId,
            languageCode: language.code,
            languageName: language.name,
            translation: updated.translation,
        };
    },

    async removeTranslation(vocabularyId: string, translationId: string): Promise<void> {
        const row = await vocabularyRepository.findTranslationById(translationId);
        if (!row || row.vocabularyId !== vocabularyId) throw new NotFoundError('Translation not found');
        await vocabularyRepository.deleteTranslation(translationId);
    },

    // ─── Examples ─────────────────────────────────────────────
    async addExample(vocabularyId: string, input: CreateExampleInput): Promise<ExampleDto> {
        const vocab = await vocabularyRepository.findCatalogById(vocabularyId);
        if (!vocab) throw new NotFoundError('Vocabulary not found');

        const created = await vocabularyRepository.createExample({
            vocabularyId,
            sentence: input.sentence,
            translation: input.translation ?? null,
            audioUrl: input.audioUrl ?? null,
            order: input.order ?? 0,
        });
        return {
            id: created.id,
            sentence: created.sentence,
            translation: created.translation,
            audioUrl: created.audioUrl,
            order: created.order,
        };
    },

    async updateExample(
        vocabularyId: string,
        exampleId: string,
        input: UpdateExampleInput,
    ): Promise<ExampleDto> {
        const row = await vocabularyRepository.findExampleById(exampleId);
        if (!row || row.vocabularyId !== vocabularyId) throw new NotFoundError('Example not found');

        const updated = await vocabularyRepository.updateExample(exampleId, input);
        return {
            id: updated.id,
            sentence: updated.sentence,
            translation: updated.translation,
            audioUrl: updated.audioUrl,
            order: updated.order,
        };
    },

    async removeExample(vocabularyId: string, exampleId: string): Promise<void> {
        const row = await vocabularyRepository.findExampleById(exampleId);
        if (!row || row.vocabularyId !== vocabularyId) throw new NotFoundError('Example not found');
        await vocabularyRepository.deleteExample(exampleId);
    },

    // ─── User vocabulary ──────────────────────────────────────
    async listMine(userId: string, query: ListMyVocabularyQuery) {
        const { page, limit, skip, take } = normalizePagination(query);
        const [rows, total] = await vocabularyRepository.listUserVocabulary(userId, query, { skip, take });
        return {
            data: rows.map(toUserDto),
            meta: buildPaginationMeta(page, limit, total),
        };
    },

    async listFavorites(userId: string) {
        const [rows] = await vocabularyRepository.listUserVocabulary(
            userId,
            { isFavorite: true },
            { skip: 0, take: 500 },
        );
        return rows.map(toUserDto);
    },

    async listDue(userId: string, query: DueVocabularyQuery): Promise<DueVocabularyDto[]> {
        const rows = await vocabularyRepository.findDue(userId, query.limit ?? 50, query.languageId);
        return rows.map(toDueDto);
    },

    /**
     * Démarre l'apprentissage d'un mot :
     * - crée l'entrée UserVocabulary si absente (state = LEARNING, nextReviewAt = now)
     * - renvoie la version existante sinon (idempotent)
     */
    async learn(userId: string, vocabularyId: string): Promise<UserVocabularyDto> {
        const vocab = await vocabularyRepository.findCatalogById(vocabularyId);
        if (!vocab) throw new NotFoundError('Vocabulary not found');

        const existing = await vocabularyRepository.findUserVocabulary(userId, vocabularyId);
        if (existing) return toUserDto(existing);

        const created = await vocabularyRepository.createUserVocabulary({
            userId,
            vocabularyId,
            state: 'LEARNING',
            nextReviewAt: new Date(),
            repetitions: 0,
            intervalDays: 0,
            easeFactor: 2.5,
        });
        return toUserDto(created);
    },

    async setFavorite(
        userId: string,
        vocabularyId: string,
        isFavorite: boolean,
    ): Promise<UserVocabularyDto> {
        const existing = await vocabularyRepository.findUserVocabulary(userId, vocabularyId);
        if (!existing) throw new NotFoundError('Vocabulary not in your list');

        const updated = await vocabularyRepository.updateUserVocabulary(existing.id, { isFavorite });
        return toUserDto(updated);
    },

    /**
     * Passe un mot à un état arbitraire (MASTERED manuel, RESET en NEW).
     * La progression fine (repetitions, intervals) est gérée par le SRS (Partie 8).
     */
    async setState(
        userId: string,
        vocabularyId: string,
        state: VocabularyState,
    ): Promise<UserVocabularyDto> {
        const existing = await vocabularyRepository.findUserVocabulary(userId, vocabularyId);
        if (!existing) throw new NotFoundError('Vocabulary not in your list');

        const now = new Date();
        const patch: Record<string, unknown> = { state };

        if (state === 'MASTERED') {
            patch.nextReviewAt = null;
            patch.lastReviewedAt = now;
        } else if (state === 'NEW') {
            patch.nextReviewAt = now;
            patch.repetitions = 0;
            patch.intervalDays = 0;
            patch.easeFactor = 2.5;
            patch.successRate = 0;
            patch.lastReviewedAt = null;
        } else if (state === 'LEARNING' || state === 'REVIEW') {
            patch.nextReviewAt = now;
        }

        const updated = await vocabularyRepository.updateUserVocabulary(existing.id, patch);
        return toUserDto(updated);
    },
};