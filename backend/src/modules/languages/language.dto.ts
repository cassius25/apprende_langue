export interface LanguageDto {
    id: string;
    code: string;
    name: string;
    nativeName: string;
    flagEmoji: string | null;
    isActive: boolean;
}

export interface LevelDto {
    id: string;
    code: string;
    name: string;
    description: string | null;
    order: number;
}