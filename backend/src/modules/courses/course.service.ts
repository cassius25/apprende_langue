import { NotFoundError } from '../../common/errors/HttpErrors';
import { buildPaginationMeta, normalizePagination } from '../../common/utils/pagination';
import { courseRepository, type CourseWithRelations } from './course.repository';
import { prisma } from '../../config/prisma';
import type {
    CourseDetailDto,
    CourseListItemDto,
    LessonMiniDto,
    ModuleDto,
} from './course.dto';
import type { CreateCourseInput, CreateModuleInput, ListCoursesQuery, UpdateCourseInput } from './course.schemas';

function toListItem(c: CourseWithRelations, lessonCount: number): CourseListItemDto {
    return {
        id: c.id,
        title: c.title,
        description: c.description,
        order: c.order,
        isPublished: c.isPublished,
        language: {
            id: c.language.id,
            code: c.language.code,
            name: c.language.name,
            flagEmoji: c.language.flagEmoji,
        },
        level: { id: c.level.id, code: c.level.code, name: c.level.name },
        moduleCount: c._count.modules,
        lessonCount,
    };
}

export const courseService = {
    async list(query: ListCoursesQuery) {
        const { page, limit, skip, take } = normalizePagination(query);

        const [rows, total] = await courseRepository.findMany(
            {
                languageId: query.languageId,
                languageCode: query.languageCode,
                levelCode: query.levelCode,
                publishedOnly: !query.includeDrafts,
            },
            { skip, take },
        );

        // Compte de leçons par cours (une seule requête groupée)
        const courseIds = rows.map((c: { id: any; }) => c.id);
        const lessonCounts = courseIds.length
            ? await prisma.lesson.groupBy({
                by: ['moduleId'],
                where: { module: { courseId: { in: courseIds }, deletedAt: null }, deletedAt: null },
                _count: { _all: true },
            })
            : [];

        const modulesByCourse = courseIds.length
            ? await prisma.module.findMany({
                where: { courseId: { in: courseIds }, deletedAt: null },
                select: { id: true, courseId: true },
            })
            : [];

        const moduleToCourse = new Map(modulesByCourse.map((m: { id: any; courseId: any; }) => [m.id, m.courseId]));
        const lessonsByCourse = new Map<string, number>();
        for (const lc of lessonCounts) {
            const courseId = moduleToCourse.get(lc.moduleId);
            if (!courseId) continue;
            lessonsByCourse.set(courseId, (lessonsByCourse.get(courseId) ?? 0) + lc._count._all);
        }

        const data = rows.map((c: { id: string; }) => toListItem(c, lessonsByCourse.get(c.id) ?? 0));
        return { data, meta: buildPaginationMeta(page, limit, total) };
    },

    async getById(id: string): Promise<CourseDetailDto> {
        const course = await courseRepository.findById(id);
        if (!course) throw new NotFoundError('Course not found');

        const modules: ModuleDto[] = course.modules.map((m: { id: any; title: any; description: any; order: any; lessons: any[]; }) => ({
            id: m.id,
            title: m.title,
            description: m.description,
            order: m.order,
            lessons: m.lessons.map<LessonMiniDto>((l: { id: any; title: any; order: any; estimatedDuration: any; isPublished: any; }) => ({
                id: l.id,
                title: l.title,
                order: l.order,
                estimatedDuration: l.estimatedDuration,
                isPublished: l.isPublished,
            })),
        }));

        const lessonCount = modules.reduce((acc, m) => acc + (m.lessons?.length ?? 0), 0);

        return {
            id: course.id,
            title: course.title,
            description: course.description,
            order: course.order,
            isPublished: course.isPublished,
            language: {
                id: course.language.id,
                code: course.language.code,
                name: course.language.name,
                flagEmoji: course.language.flagEmoji,
            },
            level: {
                id: course.level.id,
                code: course.level.code,
                name: course.level.name,
            },
            moduleCount: modules.length,
            lessonCount,
            modules,
        };
    },

    async create(input: CreateCourseInput): Promise<CourseDetailDto> {
        const created = await courseRepository.create({
            languageId: input.languageId,
            levelId: input.levelId,
            title: input.title,
            description: input.description ?? null,
            order: input.order ?? 0,
            isPublished: input.isPublished ?? false,
        });
        return this.getById(created.id);
    },

    async update(id: string, input: UpdateCourseInput): Promise<CourseDetailDto> {
        const existing = await courseRepository.findById(id);
        if (!existing) throw new NotFoundError('Course not found');
        await courseRepository.update(id, input);
        return this.getById(id);
    },

    async remove(id: string): Promise<void> {
        const existing = await courseRepository.findById(id);
        if (!existing) throw new NotFoundError('Course not found');
        await courseRepository.softDelete(id);
    },

    async addModule(courseId: string, input: CreateModuleInput): Promise<ModuleDto> {
        const course = await courseRepository.findById(courseId);
        if (!course) throw new NotFoundError('Course not found');

        const created = await courseRepository.createModule({
            courseId,
            title: input.title,
            description: input.description ?? null,
            order: input.order ?? 0,
        });
        return { id: created.id, title: created.title, description: created.description, order: created.order };
    },
};