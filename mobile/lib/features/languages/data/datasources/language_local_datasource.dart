import 'package:drift/drift.dart';

import '../../../../core/storage/drift/app_database.dart';
import '../../domain/entities/language.dart';

class LanguageLocalDataSource {
  LanguageLocalDataSource(this._db);
  final AppDatabase _db;

  Future<void> upsertAll(List<Language> languages) async {
    final now = DateTime.now();
    await _db.catalogDao.upsertLanguages([
      for (final l in languages)
        LocalLanguagesCompanion.insert(
          id: l.id,
          code: l.code,
          name: l.name,
          nativeName: l.nativeName,
          flagEmoji: Value(l.flagEmoji),
          isActive: Value(l.isActive),
          serverUpdatedAt: now,
        ),
    ]);
  }

  Future<List<Language>> readAll({bool activeOnly = true}) async {
    final rows = await _db.catalogDao.getAllLanguages(activeOnly: activeOnly);
    return rows
        .map(
          (r) => Language(
            id: r.id,
            code: r.code,
            name: r.name,
            nativeName: r.nativeName,
            flagEmoji: r.flagEmoji,
            isActive: r.isActive,
          ),
        )
        .toList(growable: false);
  }
}
