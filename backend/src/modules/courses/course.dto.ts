export interface LanguageMiniDto {
    id: string;
    code: string;
    name: string;
    flagEmoji: string | null;
}

export interface LevelMiniDto {
    id: string;
    code: string;
    name: string;
}

export interface LessonMiniDto {
    id: string;
    title: string;
    order: number;
    estimatedDuration: number;
    isPublished: boolean;
}

export interface ModuleDto {
    id: string;
    title: string;
    description: string | null;
    order: number;
    lessons?: LessonMiniDto[];
}

export interface CourseListItemDto {
    id: string;
    title: string;
    description: string | null;
    order: number;
    isPublished: boolean;
    language: LanguageMiniDto;
    level: LevelMiniDto;
    moduleCount: number;
    lessonCount: number;
}

export interface CourseDetailDto extends CourseListItemDto {
    modules: ModuleDto[];
}