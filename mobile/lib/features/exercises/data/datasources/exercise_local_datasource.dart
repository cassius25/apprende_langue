import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/storage/drift/app_database.dart';
import '../../domain/entities/exercise.dart';

class ExerciseLocalDataSource {
  ExerciseLocalDataSource(this._db);
  final AppDatabase _db;

  Future<void> cacheForLesson(String lessonId, List<Exercise> exercises) async {
    await _db.transaction(() async {
      // Récupère les ids des exercices existants pour purge des options
      final existing = await (_db.select(
        _db.localExercises,
      )..where((e) => e.lessonId.equals(lessonId))).get();
      final existingIds = existing.map((e) => e.id).toList(growable: false);

      if (existingIds.isNotEmpty) {
        await (_db.delete(
          _db.localExerciseOptions,
        )..where((o) => o.exerciseId.isIn(existingIds))).go();
      }
      await (_db.delete(
        _db.localExercises,
      )..where((e) => e.lessonId.equals(lessonId))).go();

      for (final ex in exercises) {
        await _db.catalogDao.upsertExercises([
          LocalExercisesCompanion.insert(
            id: ex.id,
            lessonId: ex.lessonId,
            type: ex.type.toApiString(),
            question: ex.question,
            dataJson: Value(ex.data == null ? null : jsonEncode(ex.data)),
            order: Value(ex.order),
          ),
        ]);
        if (ex.options.isNotEmpty) {
          await _db.catalogDao.upsertExerciseOptions([
            for (final o in ex.options)
              LocalExerciseOptionsCompanion.insert(
                id: o.id,
                exerciseId: ex.id,
                label: o.label,
                order: Value(o.order),
              ),
          ]);
        }
      }
    });
  }

  Future<List<Exercise>> readForLesson(String lessonId) async {
    final rows = await _db.catalogDao.getExercisesByLesson(lessonId);
    final out = <Exercise>[];
    for (final r in rows) {
      final opts = await _db.catalogDao.getOptionsByExercise(r.id);
      out.add(
        Exercise(
          id: r.id,
          lessonId: r.lessonId,
          type: ExerciseType.parse(r.type),
          question: r.question,
          data: r.dataJson == null ? null : _decode(r.dataJson!),
          order: r.order,
          options: opts
              .map(
                (o) => ExerciseOption(id: o.id, label: o.label, order: o.order),
              )
              .toList(growable: false),
        ),
      );
    }
    return out;
  }

  Map<String, dynamic> _decode(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      return const {};
    } catch (_) {
      return const {};
    }
  }
}
