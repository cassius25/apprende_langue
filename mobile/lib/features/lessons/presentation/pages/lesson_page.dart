import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../vocabulary/presentation/providers/vocabulary_providers.dart';
import '../../domain/entities/lesson.dart';
import '../providers/lesson_providers.dart';
import '../widgets/lesson_content_view.dart';

class LessonPage extends ConsumerStatefulWidget {
  const LessonPage({super.key, required this.lessonId});
  final String lessonId;

  @override
  ConsumerState<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends ConsumerState<LessonPage> {
  final _stopwatch = Stopwatch();
  bool _completing = false;

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  Future<void> _complete(Lesson lesson) async {
    setState(() => _completing = true);
    final seconds = (_stopwatch.elapsedMilliseconds / 1000).round();
    final result = await ref
        .read(completeLessonUseCaseProvider)
        .call(lesson.id, score: 100, timeSpentSec: seconds);
    if (!mounted) return;
    setState(() => _completing = false);
    result.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.message))),
      (c) {
        final xp = c.xpEarned > 0 ? '  +${c.xpEarned} XP' : '';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Leçon terminée !$xp')));
        ref.invalidate(lessonDetailProvider(lesson.id));
        ref.invalidate(dueVocabularyCountProvider);
        ref.invalidate(dashboardSnapshotProvider);
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(lessonDetailProvider(widget.lessonId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: async.when(
        data: (lesson) {
          final completed =
              lesson.progress?.status == LessonProgressStatus.completed;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(lesson.title, style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 6),
                    Text(
                      '${lesson.courseTitle} • ${lesson.moduleTitle} • ${lesson.estimatedDuration} min',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (lesson.contents.isEmpty)
                      const Text('Cette leçon n’a pas encore de contenu.')
                    else
                      for (final c in lesson.contents) ...[
                        LessonContentView(content: c),
                        const SizedBox(height: 16),
                      ],
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => context.push(
                          '/learn/lessons/${lesson.id}/exercises',
                        ),
                        icon: const Icon(Icons.quiz_outlined),
                        label: const Text('S’exercer sur la leçon'),
                      ),
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: _completing
                            ? null
                            : () {
                                if (completed) {
                                  context.pop();
                                } else {
                                  _complete(lesson);
                                }
                              },
                        icon: Icon(
                          completed
                              ? Icons.check_circle_rounded
                              : Icons.done_all_rounded,
                        ),
                        label: Text(
                          completed
                              ? 'Leçon déjà terminée'
                              : 'Terminer la leçon',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
