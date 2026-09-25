import 'package:drift/drift.dart';

import '../../../../core/storage/drift/app_database.dart';
import '../../domain/entities/course.dart';

class CourseLocalDataSource {
  CourseLocalDataSource(this._db);
  final AppDatabase _db;

  Future<void> cacheList(List<Course> courses) async {
    final now = DateTime.now();
    await _db.catalogDao.upsertCourses([
      for (final c in courses)
        LocalCoursesCompanion.insert(
          id: c.id,
          languageId: c.languageId,
          levelId: c.levelId,
          title: c.title,
          description: Value(c.description),
          order: Value(c.order),
          isPublished: Value(c.isPublished),
          serverUpdatedAt: now,
        ),
    ]);
  }

  Future<List<Course>> readList({String? languageId}) async {
    final rows = await _db.catalogDao.getCourses(languageId: languageId);
    return rows
        .map(
          (r) => Course(
            id: r.id,
            title: r.title,
            description: r.description,
            languageId: r.languageId,
            languageCode: '',
            levelId: r.levelId,
            levelCode: '',
            order: r.order,
            isPublished: r.isPublished,
          ),
        )
        .toList(growable: false);
  }

  Future<Course?> readOne(String id) async {
    final row = await _db.catalogDao.getCourseById(id);
    if (row == null) return null;
    final modules = await _db.catalogDao.getModulesByCourse(id);
    final modsWithLessons = <CourseModule>[];
    for (final m in modules) {
      final lessons = await _db.catalogDao.getLessonsByModule(m.id);
      modsWithLessons.add(
        CourseModule(
          id: m.id,
          title: m.title,
          description: m.description,
          order: m.order,
          lessonCount: lessons.length,
        ),
      );
    }
    return Course(
      id: row.id,
      title: row.title,
      description: row.description,
      languageId: row.languageId,
      languageCode: '',
      levelId: row.levelId,
      levelCode: '',
      order: row.order,
      isPublished: row.isPublished,
      modules: modsWithLessons,
    );
  }
}
