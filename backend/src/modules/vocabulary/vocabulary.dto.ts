export type VocabularyStateDto = 'NEW' | 'LEARNING' | 'REVIEW' | 'MASTERED';

export interface TranslationDto {
    id: string;
    languageId: string;
    languageCode: string;
    languageName: string;
    translation: string;
}

export interface ExampleDto {
    id: string;
    sentence: string;
    translation: string | null;
    audioUrl: string | null;
    order: number;
}

/** Mot vu dans le catalogue global (contenu) */
export interface VocabularyCatalogDto {
    id: string;
    word: string;
    phonetic: string | null;
    audioUrl: string | null;
    imageUrl: string | null;
    category: string | null;
    partOfSpeech: string | null;
    language: { id: string; code: string; name: string; flagEmoji: string | null };
    level: { id: string; code: string; name: string };
    translations: TranslationDto[];
    examples: ExampleDto[];
}

/** Mot personnalisé côté utilisateur (avec état d'apprentissage) */
export interface UserVocabularyDto {
    id: string; // userVocabulary id
    vocabularyId: string;
    word: string;
    phonetic: string | null;
    audioUrl: string | null;
    imageUrl: string | null;
    category: string | null;
    partOfSpeech: string | null;
    language: { id: string; code: string; name: string; flagEmoji: string | null };
    level: { id: string; code: string; name: string };
    translations: TranslationDto[];
    examples: ExampleDto[];
    state: VocabularyStateDto;
    isFavorite: boolean;
    repetitions: number;
    intervalDays: number;
    easeFactor: number;
    successRate: number;
    nextReviewAt: string | null;
    lastReviewedAt: string | null;
    createdAt: string;
}

export interface DueVocabularyDto {
    userVocabularyId: string;
    vocabularyId: string;
    word: string;
    phonetic: string | null;
    audioUrl: string | null;
    imageUrl: string | null;
    translations: TranslationDto[];
    state: VocabularyStateDto;
    nextReviewAt: string | null;
    repetitions: number;
}