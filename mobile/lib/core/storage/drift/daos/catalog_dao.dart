import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'catalog_dao.g.dart';

@DriftAccessor(
  tables: [
    LocalLanguages,
    LocalLevels,
    LocalCourses,
    LocalModules,
    LocalLessons,
    LocalLessonContents,
    LocalVocabulary,
    LocalVocabularyTranslations,
    LocalVocabularyExamples,
    LocalExercises,
    LocalExerciseOptions,
  ],
)
class CatalogDao extends DatabaseAccessor<AppDatabase> with _$CatalogDaoMixin {
  CatalogDao(super.db);

  // ─────────────────────────────────────────────────────────
  // Languages
  // ─────────────────────────────────────────────────────────
  Future<List<LocalLanguage>> getAllLanguages({bool activeOnly = true}) {
    final query = select(localLanguages)
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);
    if (activeOnly) query.where((t) => t.isActive.equals(true));
    return query.get();
  }

  Future<LocalLanguage?> getLanguageById(String id) {
    return (select(
      localLanguages,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsertLanguage(LocalLanguagesCompanion row) {
    return into(localLanguages).insertOnConflictUpdate(row);
  }

  Future<void> upsertLanguages(List<LocalLanguagesCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localLanguages, rows));
  }

  // ─────────────────────────────────────────────────────────
  // Levels
  // ─────────────────────────────────────────────────────────
  Future<List<LocalLevel>> getAllLevels() {
    return (select(
      localLevels,
    )..orderBy([(t) => OrderingTerm.asc(t.order)])).get();
  }

  Future<void> upsertLevels(List<LocalLevelsCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localLevels, rows));
  }

  // ─────────────────────────────────────────────────────────
  // Courses
  // ─────────────────────────────────────────────────────────
  Future<List<LocalCourse>> getCourses({
    String? languageId,
    String? levelId,
    bool publishedOnly = true,
  }) {
    final q = select(localCourses)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.asc(t.order)]);
    if (languageId != null) q.where((t) => t.languageId.equals(languageId));
    if (levelId != null) q.where((t) => t.levelId.equals(levelId));
    if (publishedOnly) q.where((t) => t.isPublished.equals(true));
    return q.get();
  }

  Future<LocalCourse?> getCourseById(String id) {
    return (select(
      localCourses,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsertCourses(List<LocalCoursesCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localCourses, rows));
  }

  // ─────────────────────────────────────────────────────────
  // Modules
  // ─────────────────────────────────────────────────────────
  Future<List<LocalModule>> getModulesByCourse(String courseId) {
    return (select(localModules)
          ..where((t) => t.courseId.equals(courseId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.order)]))
        .get();
  }

  Future<void> upsertModules(List<LocalModulesCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localModules, rows));
  }

  // ─────────────────────────────────────────────────────────
  // Lessons
  // ─────────────────────────────────────────────────────────
  Future<List<LocalLesson>> getLessonsByModule(String moduleId) {
    return (select(localLessons)
          ..where((t) => t.moduleId.equals(moduleId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.order)]))
        .get();
  }

  Future<LocalLesson?> getLessonById(String id) {
    return (select(
      localLessons,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsertLessons(List<LocalLessonsCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localLessons, rows));
  }

  // ─────────────────────────────────────────────────────────
  // Lesson contents
  // ─────────────────────────────────────────────────────────
  Future<List<LocalLessonContent>> getContentsByLesson(String lessonId) {
    return (select(localLessonContents)
          ..where((t) => t.lessonId.equals(lessonId))
          ..orderBy([(t) => OrderingTerm.asc(t.order)]))
        .get();
  }

  Future<void> replaceContentsForLesson(
    String lessonId,
    List<LocalLessonContentsCompanion> rows,
  ) async {
    await transaction(() async {
      await (delete(
        localLessonContents,
      )..where((t) => t.lessonId.equals(lessonId))).go();
      await batch((b) => b.insertAll(localLessonContents, rows));
    });
  }

  // ─────────────────────────────────────────────────────────
  // Vocabulary (catalogue)
  // ─────────────────────────────────────────────────────────
  Future<List<LocalVocabularyData>> searchVocabulary({
    String? languageId,
    String? levelId,
    String? category,
    String? search,
    int limit = 100,
  }) {
    final q = select(localVocabulary)
      ..where((t) => t.deletedAt.isNull())
      ..limit(limit);
    if (languageId != null) q.where((t) => t.languageId.equals(languageId));
    if (levelId != null) q.where((t) => t.levelId.equals(levelId));
    if (category != null) q.where((t) => t.category.equals(category));
    if (search != null && search.isNotEmpty) {
      q.where((t) => t.word.like('%${search.toLowerCase()}%'));
    }
    q.orderBy([(t) => OrderingTerm.asc(t.word)]);
    return q.get();
  }

  Future<LocalVocabularyData?> getVocabularyById(String id) {
    return (select(
      localVocabulary,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<LocalVocabularyTranslation>> getTranslationsFor(
    String vocabularyId,
  ) {
    return (select(
      localVocabularyTranslations,
    )..where((t) => t.vocabularyId.equals(vocabularyId))).get();
  }

  Future<List<LocalVocabularyExample>> getExamplesFor(String vocabularyId) {
    return (select(localVocabularyExamples)
          ..where((t) => t.vocabularyId.equals(vocabularyId))
          ..orderBy([(t) => OrderingTerm.asc(t.order)]))
        .get();
  }

  Future<void> upsertVocabulary(List<LocalVocabularyCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localVocabulary, rows));
  }

  Future<void> upsertTranslations(
    List<LocalVocabularyTranslationsCompanion> rows,
  ) async {
    await batch(
      (b) => b.insertAllOnConflictUpdate(localVocabularyTranslations, rows),
    );
  }

  Future<void> upsertExamples(
    List<LocalVocabularyExamplesCompanion> rows,
  ) async {
    await batch(
      (b) => b.insertAllOnConflictUpdate(localVocabularyExamples, rows),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Exercises
  // ─────────────────────────────────────────────────────────
  Future<List<LocalExercise>> getExercisesByLesson(String lessonId) {
    return (select(localExercises)
          ..where((t) => t.lessonId.equals(lessonId))
          ..orderBy([(t) => OrderingTerm.asc(t.order)]))
        .get();
  }

  Future<List<LocalExerciseOption>> getOptionsByExercise(String exerciseId) {
    return (select(localExerciseOptions)
          ..where((t) => t.exerciseId.equals(exerciseId))
          ..orderBy([(t) => OrderingTerm.asc(t.order)]))
        .get();
  }

  Future<void> upsertExercises(List<LocalExercisesCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localExercises, rows));
  }

  Future<void> upsertExerciseOptions(
    List<LocalExerciseOptionsCompanion> rows,
  ) async {
    await batch((b) => b.insertAllOnConflictUpdate(localExerciseOptions, rows));
  }
}
