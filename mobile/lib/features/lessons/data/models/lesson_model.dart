import '../../domain/entities/lesson.dart';

class LessonModel {
  const LessonModel({required this.json});
  final Map<String, dynamic> json;

  factory LessonModel.fromApi(Map<String, dynamic> json) =>
      LessonModel(json: json);

  Lesson toEntity() {
    final module = json['module'] as Map<String, dynamic>? ?? const {};
    final course = json['course'] as Map<String, dynamic>? ?? const {};
    final lang = json['language'] as Map<String, dynamic>? ?? const {};
    final level = json['level'] as Map<String, dynamic>? ?? const {};
    final contents = (json['contents'] as List?) ?? const [];
    final progress = json['progress'] as Map<String, dynamic>?;

    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      moduleId: module['id'] as String? ?? '',
      moduleTitle: module['title'] as String? ?? '',
      courseId: course['id'] as String? ?? '',
      courseTitle: course['title'] as String? ?? '',
      languageCode: lang['code'] as String? ?? '',
      levelCode: level['code'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      estimatedDuration: (json['estimatedDuration'] as num?)?.toInt() ?? 5,
      isPublished: json['isPublished'] as bool? ?? false,
      contents: contents
          .whereType<Map>()
          .map(
            (c) => LessonContent(
              id: c['id'] as String,
              type: _parseType(c['type'] as String? ?? 'TEXT'),
              content: c['content'] as String? ?? '',
              order: (c['order'] as num?)?.toInt() ?? 0,
            ),
          )
          .toList(growable: false),
      progress: progress == null
          ? null
          : LessonProgress(
              status: _parseStatus(
                progress['status'] as String? ?? 'NOT_STARTED',
              ),
              score: (progress['score'] as num?)?.toInt() ?? 0,
              timeSpentSec: (progress['timeSpentSec'] as num?)?.toInt() ?? 0,
              completedAt: DateTime.tryParse(
                progress['completedAt'] as String? ?? '',
              )?.toLocal(),
            ),
    );
  }

  static LessonContentType _parseType(String raw) {
    switch (raw) {
      case 'IMAGE':
        return LessonContentType.image;
      case 'AUDIO':
        return LessonContentType.audio;
      case 'VIDEO':
        return LessonContentType.video;
      case 'MARKDOWN':
        return LessonContentType.markdown;
      default:
        return LessonContentType.text;
    }
  }

  static LessonProgressStatus _parseStatus(String raw) {
    switch (raw) {
      case 'COMPLETED':
        return LessonProgressStatus.completed;
      case 'IN_PROGRESS':
        return LessonProgressStatus.inProgress;
      default:
        return LessonProgressStatus.notStarted;
    }
  }
}

class LessonCompletionModel {
  const LessonCompletionModel({required this.json});
  final Map<String, dynamic> json;

  int get xpEarned => (json['xpEarned'] as num?)?.toInt() ?? 0;
  int get totalXp => (json['totalXp'] as num?)?.toInt() ?? 0;
  int get userLevel => (json['userLevel'] as num?)?.toInt() ?? 1;

  LessonProgress get progress {
    final p = json['progress'] as Map<String, dynamic>? ?? const {};
    return LessonProgress(
      status: LessonModel._parseStatus(p['status'] as String? ?? 'COMPLETED'),
      score: (p['score'] as num?)?.toInt() ?? 0,
      timeSpentSec: (p['timeSpentSec'] as num?)?.toInt() ?? 0,
      completedAt: DateTime.tryParse(
        p['completedAt'] as String? ?? '',
      )?.toLocal(),
    );
  }
}
