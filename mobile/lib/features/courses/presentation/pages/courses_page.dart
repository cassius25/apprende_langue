import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../lessons/presentation/providers/lesson_providers.dart';
import '../../domain/entities/course.dart';
import '../providers/course_providers.dart';

class CoursesPage extends ConsumerWidget {
  const CoursesPage({super.key, this.languageId});
  final String? languageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = CoursesQuery(languageId: languageId);
    final async = ref.watch(coursesProvider(query));

    return Scaffold(
      appBar: AppBar(title: const Text('Cours')),
      body: async.when(
        data: (courses) {
          if (courses.isEmpty) {
            return const Center(child: Text('Aucun cours pour cette langue.'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(coursesProvider(query)),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _CourseTile(course: courses[i]),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: 8),
              Text('$e'),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => ref.invalidate(coursesProvider(query)),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/learn/courses/${course.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      course.levelCode,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                ],
              ),
              const SizedBox(height: 10),
              Text(course.title, style: theme.textTheme.titleMedium),
              if (course.description != null) ...[
                const SizedBox(height: 4),
                Text(
                  course.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                '${course.moduleCount} modules • ${course.lessonCount} leçons',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// évite un avertissement d'import inutilisé
// ignore: unused_element
void _keep(WidgetRef ref) => ref.read(lessonsByModuleProvider(''));
