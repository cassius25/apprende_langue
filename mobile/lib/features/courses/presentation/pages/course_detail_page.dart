import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../lessons/presentation/providers/lesson_providers.dart';
import '../../domain/entities/course.dart';
import '../providers/course_providers.dart';

class CourseDetailPage extends ConsumerWidget {
  const CourseDetailPage({super.key, required this.courseId});
  final String courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(courseDetailProvider(courseId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: async.when(
        data: (course) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    course.levelCode,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(course.title, style: theme.textTheme.headlineMedium),
            if (course.description != null) ...[
              const SizedBox(height: 8),
              Text(
                course.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (course.modules.isEmpty)
              const Text('Aucun module pour ce cours.')
            else
              ...course.modules.map((m) => _ModuleSection(module: m)),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}

class _ModuleSection extends ConsumerWidget {
  const _ModuleSection({required this.module});
  final CourseModule module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(lessonsByModuleProvider(module.id));
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(module.title, style: theme.textTheme.titleMedium),
              ),
              Text(
                '${module.lessonCount} leçons',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
          if (module.description != null) ...[
            const SizedBox(height: 4),
            Text(
              module.description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 8),
          async.when(
            data: (lessons) {
              if (lessons.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Aucune leçon.'),
                );
              }
              return Column(
                children: [
                  for (final l in lessons)
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          foregroundColor: AppColors.primary,
                          child: Text(
                            '${l.order}',
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                        title: Text(l.title),
                        subtitle: Text('${l.estimatedDuration} min'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.push('/learn/lessons/${l.id}'),
                      ),
                    ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Erreur : $e'),
          ),
        ],
      ),
    );
  }
}
