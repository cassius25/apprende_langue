import 'package:drift/drift.dart';

import '../../../../core/storage/drift/app_database.dart';
import '../../domain/entities/lesson.dart';

class LessonLocalDataSource {
  LessonLocalDataSource(this._db);
  final AppDatabase _db;

  Future<void> cache(Lesson lesson) async {
    final now = DateTime.now();
    await _db.catalogDao.upsertLessons([
      LocalLessonsCompanion.insert(
        id: lesson.id,
        moduleId: lesson.moduleId,
        title: lesson.title,
        description: Value(lesson.description),
        order: Value(lesson.order),
        estimatedDuration: Value(lesson.estimatedDuration),
        isPublished: Value(lesson.isPublished),
        serverUpdatedAt: now,
      ),
    ]);
    await _db.catalogDao.replaceContentsForLesson(lesson.id, [
      for (final c in lesson.contents)
        LocalLessonContentsCompanion.insert(
          id: c.id,
          lessonId: lesson.id,
          type: c.type.name.toUpperCase(),
          content: c.content,
          order: Value(c.order),
        ),
    ]);
  }

  Future<Lesson?> read(String id) async {
    final row = await _db.catalogDao.getLessonById(id);
    if (row == null) return null;
    final contents = await _db.catalogDao.getContentsByLesson(id);
    return Lesson(
      id: row.id,
      title: row.title,
      description: row.description,
      moduleId: row.moduleId,
      moduleTitle: '',
      courseId: '',
      courseTitle: '',
      languageCode: '',
      levelCode: '',
      order: row.order,
      estimatedDuration: row.estimatedDuration,
      isPublished: row.isPublished,
      contents: contents
          .map(
            (c) => LessonContent(
              id: c.id,
              type: _parse(c.type),
              content: c.content,
              order: c.order,
            ),
          )
          .toList(growable: false),
    );
  }

  Future<List<LessonMini>> listByModule(String moduleId) async {
    final rows = await _db.catalogDao.getLessonsByModule(moduleId);
    return rows
        .map(
          (r) => LessonMini(
            id: r.id,
            title: r.title,
            order: r.order,
            estimatedDuration: r.estimatedDuration,
            isPublished: r.isPublished,
          ),
        )
        .toList(growable: false);
  }

  LessonContentType _parse(String raw) {
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

  /// Persiste la progression après complétion.
  Future<void> saveProgress({
    required String userId,
    required String lessonId,
    required String status,
    int score = 0,
    int timeSpentSec = 0,
    DateTime? completedAt,
  }) async {
    final existing = await _db.progressDao.getByLesson(userId, lessonId);
    final id = existing?.id ?? '$userId:$lessonId';
    await _db.progressDao.upsert(
      LocalUserProgressCompanion.insert(
        id: id,
        userId: userId,
        lessonId: lessonId,
        status: status,
        score: Value(score),
        timeSpentSec: Value(timeSpentSec),
        completedAt: Value(completedAt),
        serverUpdatedAt: DateTime.now(),
      ),
    );
  }
}
