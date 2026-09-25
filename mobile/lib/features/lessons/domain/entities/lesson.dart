import 'package:equatable/equatable.dart';

enum LessonContentType { text, image, audio, video, markdown }

class LessonContent extends Equatable {
  const LessonContent({
    required this.id,
    required this.type,
    required this.content,
    required this.order,
  });

  final String id;
  final LessonContentType type;
  final String content;
  final int order;

  @override
  List<Object?> get props => [id, type, content, order];
}

enum LessonProgressStatus { notStarted, inProgress, completed }

class LessonProgress extends Equatable {
  const LessonProgress({
    required this.status,
    required this.score,
    required this.timeSpentSec,
    this.completedAt,
  });

  final LessonProgressStatus status;
  final int score;
  final int timeSpentSec;
  final DateTime? completedAt;

  @override
  List<Object?> get props => [status, score, timeSpentSec, completedAt];
}

class Lesson extends Equatable {
  const Lesson({
    required this.id,
    required this.title,
    required this.moduleId,
    required this.moduleTitle,
    required this.courseId,
    required this.courseTitle,
    required this.languageCode,
    required this.levelCode,
    this.description,
    this.order = 0,
    this.estimatedDuration = 5,
    this.isPublished = false,
    this.contents = const [],
    this.progress,
  });

  final String id;
  final String title;
  final String? description;
  final String moduleId;
  final String moduleTitle;
  final String courseId;
  final String courseTitle;
  final String languageCode;
  final String levelCode;
  final int order;
  final int estimatedDuration;
  final bool isPublished;
  final List<LessonContent> contents;
  final LessonProgress? progress;

  @override
  List<Object?> get props => [id, title];
}

class LessonMini extends Equatable {
  const LessonMini({
    required this.id,
    required this.title,
    required this.order,
    required this.estimatedDuration,
    this.isPublished = true,
    this.completed = false,
  });

  final String id;
  final String title;
  final int order;
  final int estimatedDuration;
  final bool isPublished;
  final bool completed;

  @override
  List<Object?> get props => [id];
}
