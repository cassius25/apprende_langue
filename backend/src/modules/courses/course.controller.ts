import type { Request, Response } from 'express';
import { courseService } from './course.service';
import type {
    CreateCourseInput,
    CreateModuleInput,
    ListCoursesQuery,
    UpdateCourseInput,
} from './course.schemas';

export const courseController = {
    async list(req: Request, res: Response): Promise<void> {
        const result = await courseService.list(req.query as unknown as ListCoursesQuery);
        res.status(200).json({ success: true, data: result.data, meta: result.meta });
    },

    async getById(req: Request, res: Response): Promise<void> {
        const course = await courseService.getById(req.params.id);
        res.status(200).json({ success: true, data: course });
    },

    async create(req: Request, res: Response): Promise<void> {
        const created = await courseService.create(req.body as CreateCourseInput);
        res.status(201).json({ success: true, data: created });
    },

    async update(req: Request, res: Response): Promise<void> {
        const updated = await courseService.update(req.params.id, req.body as UpdateCourseInput);
        res.status(200).json({ success: true, data: updated });
    },

    async remove(req: Request, res: Response): Promise<void> {
        await courseService.remove(req.params.id);
        res.status(204).send();
    },

    async addModule(req: Request, res: Response): Promise<void> {
        const created = await courseService.addModule(req.params.id, req.body as CreateModuleInput);
        res.status(201).json({ success: true, data: created });
    },
};