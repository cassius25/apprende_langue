import type { Language } from '../../generated/prisma/client';
import { ConflictError, NotFoundError } from '../../common/errors/HttpErrors';
import { languageRepository } from './language.repository';
import type { LanguageDto, LevelDto } from './language.dto';
import type { CreateLanguageInput, UpdateLanguageInput } from './language.schemas';

function toDto(l: Language): LanguageDto {
    return {
        id: l.id,
        code: l.code,
        name: l.name,
        nativeName: l.nativeName,
        flagEmoji: l.flagEmoji,
        isActive: l.isActive,
    };
}

export const languageService = {
    async list(activeOnly: boolean): Promise<LanguageDto[]> {
        const rows = await languageRepository.findAll(activeOnly);
        return rows.map(toDto);
    },

    async getById(id: string): Promise<LanguageDto> {
        const lang = await languageRepository.findById(id);
        if (!lang) throw new NotFoundError('Language not found');
        return toDto(lang);
    },

    async listLevels(languageId: string): Promise<LevelDto[]> {
        const lang = await languageRepository.findById(languageId);
        if (!lang) throw new NotFoundError('Language not found');

        const levels = await languageRepository.findLevelsByLanguage(languageId);
        return levels.map((l: { id: any; code: any; name: any; description: any; order: any; }) => ({
            id: l.id,
            code: l.code,
            name: l.name,
            description: l.description,
            order: l.order,
        }));
    },

    async create(input: CreateLanguageInput): Promise<LanguageDto> {
        const existing = await languageRepository.findByCode(input.code);
        if (existing) throw new ConflictError('Language code already exists');

        const created = await languageRepository.create({
            code: input.code,
            name: input.name,
            nativeName: input.nativeName,
            flagEmoji: input.flagEmoji ?? null,
            isActive: input.isActive ?? true,
        });
        return toDto(created);
    },

    async update(id: string, input: UpdateLanguageInput): Promise<LanguageDto> {
        const lang = await languageRepository.findById(id);
        if (!lang) throw new NotFoundError('Language not found');

        if (input.code && input.code !== lang.code) {
            const clash = await languageRepository.findByCode(input.code);
            if (clash && clash.id !== id) throw new ConflictError('Language code already exists');
        }

        const updated = await languageRepository.update(id, input);
        return toDto(updated);
    },

    async remove(id: string): Promise<void> {
        const lang = await languageRepository.findById(id);
        if (!lang) throw new NotFoundError('Language not found');
        await languageRepository.softDelete(id);
    },
};