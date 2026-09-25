import 'package:drift/drift.dart';

// ════════════════════════════════════════════════════════════════
// CATALOG — miroir local du contenu backend (lecture seule côté client)
// ════════════════════════════════════════════════════════════════

class LocalLanguages extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get nativeName => text()();
  TextColumn get flagEmoji => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get serverUpdatedAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalLevels extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get order => integer()();
  DateTimeColumn get serverUpdatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalCourses extends Table {
  TextColumn get id => text()();
  TextColumn get languageId => text()();
  TextColumn get levelId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get order => integer().withDefault(const Constant(0))();
  BoolColumn get isPublished => boolean().withDefault(const Constant(false))();
  DateTimeColumn get serverUpdatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalModules extends Table {
  TextColumn get id => text()();
  TextColumn get courseId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get order => integer().withDefault(const Constant(0))();
  DateTimeColumn get serverUpdatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalLessons extends Table {
  TextColumn get id => text()();
  TextColumn get moduleId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get order => integer().withDefault(const Constant(0))();
  IntColumn get estimatedDuration => integer().withDefault(const Constant(5))();
  BoolColumn get isPublished => boolean().withDefault(const Constant(false))();
  DateTimeColumn get serverUpdatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalLessonContents extends Table {
  TextColumn get id => text()();
  TextColumn get lessonId => text()();
  TextColumn get type => text()(); // TEXT | IMAGE | AUDIO | VIDEO | MARKDOWN
  TextColumn get content => text()();
  IntColumn get order => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalVocabulary extends Table {
  TextColumn get id => text()();
  TextColumn get languageId => text()();
  TextColumn get levelId => text()();
  TextColumn get word => text()();
  TextColumn get phonetic => text().nullable()();
  TextColumn get audioUrl => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get partOfSpeech => text().nullable()();
  DateTimeColumn get serverUpdatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalVocabularyTranslations extends Table {
  TextColumn get id => text()();
  TextColumn get vocabularyId => text()();
  TextColumn get languageId => text()();
  TextColumn get languageCode => text()();
  TextColumn get translation => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalVocabularyExamples extends Table {
  TextColumn get id => text()();
  TextColumn get vocabularyId => text()();
  TextColumn get sentence => text()();
  TextColumn get translation => text().nullable()();
  TextColumn get audioUrl => text().nullable()();
  IntColumn get order => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalExercises extends Table {
  TextColumn get id => text()();
  TextColumn get lessonId => text()();
  TextColumn get type => text()(); // MULTIPLE_CHOICE | TRANSLATION | ...
  TextColumn get question => text()();
  TextColumn get dataJson => text().nullable()();
  IntColumn get order => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalExerciseOptions extends Table {
  TextColumn get id => text()();
  TextColumn get exerciseId => text()();
  TextColumn get label => text()();
  IntColumn get order => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ════════════════════════════════════════════════════════════════
// USER — données locales de l'utilisateur (syncables)
// ════════════════════════════════════════════════════════════════

class LocalUserProfile extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get role => text()();
  BoolColumn get emailVerified =>
      boolean().withDefault(const Constant(false))();
  TextColumn get nativeLanguageId => text().nullable()();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  IntColumn get userLevel => integer().withDefault(const Constant(1))();
  DateTimeColumn get serverUpdatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalUserLanguages extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get languageId => text()();
  TextColumn get levelId => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  RealColumn get progressPercent => real().withDefault(const Constant(0))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get serverUpdatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalUserProgress extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get lessonId => text()();
  TextColumn get status => text()(); // NOT_STARTED | IN_PROGRESS | COMPLETED
  IntColumn get score => integer().withDefault(const Constant(0))();
  IntColumn get timeSpentSec => integer().withDefault(const Constant(0))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get serverUpdatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalUserVocabulary extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get vocabularyId => text()();
  TextColumn get state => text()(); // NEW | LEARNING | REVIEW | MASTERED
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  RealColumn get successRate => real().withDefault(const Constant(0))();
  RealColumn get difficulty => real().withDefault(const Constant(0))();
  DateTimeColumn get nextReviewAt => dateTime().nullable()();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
  DateTimeColumn get serverUpdatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalDailyGoals extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get type => text()(); // MINUTES | WORDS
  IntColumn get target => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get serverUpdatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalStreaks extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  IntColumn get totalActiveDays => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActiveDate => dateTime().nullable()();
  DateTimeColumn get serverUpdatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalDailyActivities extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get minutesLearned => integer().withDefault(const Constant(0))();
  IntColumn get wordsLearned => integer().withDefault(const Constant(0))();
  IntColumn get wordsReviewed => integer().withDefault(const Constant(0))();
  IntColumn get exercisesDone => integer().withDefault(const Constant(0))();
  IntColumn get exercisesCorrect => integer().withDefault(const Constant(0))();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
  DateTimeColumn get serverUpdatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalUserBadges extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get badgeId => text()();
  DateTimeColumn get earnedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ════════════════════════════════════════════════════════════════
// SYNC — outbox locale (file d'attente d'opérations à pousser)
// ════════════════════════════════════════════════════════════════

class SyncQueueEntries extends Table {
  TextColumn get id => text()(); // UUID client (idempotence)
  TextColumn get entity =>
      text()(); // user_vocabulary | user_progress | daily_goals | user_languages
  TextColumn get entityId => text()();
  TextColumn get op => text()(); // UPSERT | DELETE
  TextColumn get payloadJson => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  // pending | in_flight | synced | failed
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get clientTimestamp => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
