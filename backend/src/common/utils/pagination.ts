export interface PaginationInput {
    page?: number;
    limit?: number;
}

export interface PaginationMeta {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
    hasNext: boolean;
    hasPrev: boolean;
}

export function normalizePagination(input: PaginationInput = {}) {
    const page = Math.max(1, Math.floor(input.page ?? 1));
    const limit = Math.min(100, Math.max(1, Math.floor(input.limit ?? 20)));
    return { page, limit, skip: (page - 1) * limit, take: limit };
}

export function buildPaginationMeta(page: number, limit: number, total: number): PaginationMeta {
    const totalPages = Math.max(1, Math.ceil(total / limit));
    return {
        page,
        limit,
        total,
        totalPages,
        hasNext: page < totalPages,
        hasPrev: page > 1,
    };
}