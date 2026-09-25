import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'user_dao.g.dart';

@DriftAccessor(
  tables: [
    LocalUserProfile,
    LocalUserLanguages,
    LocalUserProgress,
    LocalUserVocabulary,
    LocalStreaks,
    LocalDailyActivities,
    LocalDailyGoals,
    LocalUserBadges,
  ],
)
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  // ─────────────────────────────────────────────────────────
  // Profile
  // ─────────────────────────────────────────────────────────
  Future<LocalUserProfileData?> getProfile() {
    return select(localUserProfile).getSingleOrNull();
  }

  Future<void> upsertProfile(LocalUserProfileCompanion row) {
    return into(localUserProfile).insertOnConflictUpdate(row);
  }

  Future<void> clearProfile() => delete(localUserProfile).go();

  // ─────────────────────────────────────────────────────────
  // User languages
  // ─────────────────────────────────────────────────────────
  Future<List<LocalUserLanguage>> getUserLanguages({bool activeOnly = true}) {
    final q = select(localUserLanguages)..where((t) => t.deletedAt.isNull());
    if (activeOnly) q.where((t) => t.isActive.equals(true));
    return q.get();
  }

  Future<LocalUserLanguage?> getUserLanguage(String languageId) {
    return (select(
          localUserLanguages,
        )..where((t) => t.languageId.equals(languageId) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<void> upsertUserLanguage(LocalUserLanguagesCompanion row) {
    return into(localUserLanguages).insertOnConflictUpdate(row);
  }

  Future<void> upsertUserLanguages(
    List<LocalUserLanguagesCompanion> rows,
  ) async {
    await batch((b) => b.insertAllOnConflictUpdate(localUserLanguages, rows));
  }

  // ─────────────────────────────────────────────────────────
  // Streak
  // ─────────────────────────────────────────────────────────
  Future<LocalStreak?> getStreak() {
    return select(localStreaks).getSingleOrNull();
  }

  Future<void> upsertStreak(LocalStreaksCompanion row) {
    return into(localStreaks).insertOnConflictUpdate(row);
  }

  // ─────────────────────────────────────────────────────────
  // Daily activity
  // ─────────────────────────────────────────────────────────
  Future<List<LocalDailyActivity>> getActivityRange(
    DateTime from,
    DateTime to,
  ) {
    return (select(localDailyActivities)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(from) &
                t.date.isSmallerOrEqualValue(to),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  Future<LocalDailyActivity?> getTodayActivity() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return (select(
      localDailyActivities,
    )..where((t) => t.date.equals(today))).getSingleOrNull();
  }

  Future<void> upsertDailyActivity(LocalDailyActivitiesCompanion row) {
    return into(localDailyActivities).insertOnConflictUpdate(row);
  }

  Future<void> upsertDailyActivities(
    List<LocalDailyActivitiesCompanion> rows,
  ) async {
    await batch((b) => b.insertAllOnConflictUpdate(localDailyActivities, rows));
  }

  // ─────────────────────────────────────────────────────────
  // Daily goals
  // ─────────────────────────────────────────────────────────
  Future<List<LocalDailyGoal>> getActiveGoals() {
    return (select(
      localDailyGoals,
    )..where((t) => t.isActive.equals(true))).get();
  }

  Future<LocalDailyGoal?> getGoalByType(String type) {
    return (select(localDailyGoals)
          ..where((t) => t.type.equals(type) & t.isActive.equals(true)))
        .getSingleOrNull();
  }

  Future<void> upsertDailyGoal(LocalDailyGoalsCompanion row) {
    return into(localDailyGoals).insertOnConflictUpdate(row);
  }

  // ─────────────────────────────────────────────────────────
  // Badges
  // ─────────────────────────────────────────────────────────
  Future<List<LocalUserBadge>> getBadges() {
    return (select(
      localUserBadges,
    )..orderBy([(t) => OrderingTerm.desc(t.earnedAt)])).get();
  }

  Future<void> upsertBadges(List<LocalUserBadgesCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localUserBadges, rows));
  }

  // ─────────────────────────────────────────────────────────
  // Wipe user data (logout)
  // ─────────────────────────────────────────────────────────
  Future<void> wipeUserData() async {
    await transaction(() async {
      await delete(localUserProfile).go();
      await delete(localUserLanguages).go();
      await delete(localUserProgress).go();
      await delete(localUserVocabulary).go();
      await delete(localDailyGoals).go();
      await delete(localStreaks).go();
      await delete(localDailyActivities).go();
      await delete(localUserBadges).go();
    });
  }
}
