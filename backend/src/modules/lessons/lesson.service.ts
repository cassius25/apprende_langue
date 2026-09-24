import { NotFoundError } from '../../common/errors/HttpErrors';
import { recordActivity } from '../../common/utils/engagement';
import { lessonRepository, type LessonWithRelations } from './lesson.repository';
import type {
    CompleteLessonInput,
    CreateLessonInput,
    UpdateLessonInput,
} from './lesson.schemas';
import type {
    ExerciseClientDto,
    LessonCompletionResult,
    LessonDetailDto,
    LessonProgressDto,
} from './lesson.dto';

function toProgressDto(
    p: { status: string; score: number; timeSpentSec: number; completedAt: Date | null } | null,
): LessonProgressDto | null {
    if (!p) return null;
    return {
        status: p.status as LessonProgressDto['status'],
        score: p.score,
        timeSpentSec: p.timeSpentSec,
        completedAt: p.completedAt ? p.completedAt.toISOString() : null,
    };
}

function toDetail(l: LessonWithRelations, progress: LessonProgressDto | null): LessonDetailDto {
    const exercises: ExerciseClientDto[] = l.exercises.map((e) => ({
        id: e.id,
        type: e.type as ExerciseClientDto['type'],
        question: e.question,
        data: e.data,
        order: e.order,
        options: e.options.map((o) => ({ id: o.id, label: o.label, order: o.order })),
    }));

    return {
        id: l.id,
        title: l.title,
        description: l.description,
        order: l.order,
        estimatedDuration: l.estimatedDuration,
        isPublished: l.isPublished,
        module: { id: l.module.id, title: l.module.title },
        course: { id: l.module.course.id, title: l.module.course.title },
        language: {
            id: l.module.course.language.id,
            code: l.module.course.language.code,
            name: l.module.course.language.name,
            flagEmoji: l.module.course.language.flagEmoji,
        },
        level: {
            id: l.module.course.level.id,
            code: l.module.course.level.code,
            name: l.module.course.level.name,
        },
        contents: l.contents.map((c) => ({
            id: c.id,
            type: c.type as LessonDetailDto['contents'][number]['type'],
            content: c.content,
            order: c.order,
        })),
        exercises,
        progress,
    };
}

export const lessonService = {
    async getById(id: string, userId?: string): Promise<LessonDetailDto> {
        const lesson = await lessonRepository.findById(id);
        if (!lesson) throw new NotFoundError('Lesson not found');

        const progressRow = userId ? await lessonRepository.findProgress(userId, id) : null;
        return toDetail(lesson, toProgressDto(progressRow));
    },

    async complete(
        id: string,
        userId: string,
        input: CompleteLessonInput,
    ): Promise<LessonCompletionResult> {
        const lesson = await lessonRepository.findById(id);
        if (!lesson) throw new NotFoundError('Lesson not found');

        const now = new Date();
        const score = input.score ?? 100;

        // XP de base : 10 + moitié de la durée estimée.
        const baseXp = 10 + Math.floor(lesson.estimatedDuration / 2);
        // Bonus proportionnel au score (jusqu'à +50 %).
        const xpEarned = Math.round(baseXp * (1 + score / 200));

        await lessonRepository.upsertProgress(userId, id, {
            status: 'COMPLETED',
            score,
            timeSpentSec: input.timeSpentSec ?? lesson.estimatedDuration * 60,
            completedAt: now,
        });

        const activity = await recordActivity(userId, {
            xp: xpEarned,
            minutes: Math.max(1, Math.round((input.timeSpentSec ?? lesson.estimatedDuration * 60) / 60)),
            markActiveDay: true,
        });

        const fresh = await lessonRepository.findProgress(userId, id);

        return {
            progress: toProgressDto(fresh)!,
            xpEarned: activity.xpEarned,
            totalXp: activity.totalXp,
            userLevel: activity.userLevel,
            streak: activity.streak,
            newBadges: activity.newBadges,
        };
    },

    async create(moduleId: string, input: CreateLessonInput): Promise<LessonDetailDto> {
        const mod = await lessonRepository.findModuleById(moduleId);
        if (!mod) throw new NotFoundError('Module not found');

        const created = await lessonRepository.create({
            moduleId,
            title: input.title,
            description: input.description ?? null,
            order: input.order ?? 0,
            estimatedDuration: input.estimatedDuration ?? 5,
            isPublished: input.isPublished ?? false,
        });

        return this.getById(created.id);
    },

    async update(id: string, input: UpdateLessonInput): Promise<LessonDetailDto> {
        const existing = await lessonRepository.findById(id);
        if (!existing) throw new NotFoundError('Lesson not found');

        await lessonRepository.update(id, input);
        return this.getById(id);
    },

    async remove(id: string): Promise<void> {
        const existing = await lessonRepository.findById(id);
        if (!existing) throw new NotFoundError('Lesson not found');
        await lessonRepository.softDelete(id);
    },
};