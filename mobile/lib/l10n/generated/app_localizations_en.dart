// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'LangApp';

  @override
  String get appTagline => 'Learn languages, one day at a time';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonClose => 'Close';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonFinish => 'Finish';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonNoInternet => 'No internet connection';

  @override
  String get splashLoading => 'Loading…';

  @override
  String get navHome => 'Home';

  @override
  String get navLearn => 'Learn';

  @override
  String get navReview => 'Review';

  @override
  String get navStatistics => 'Statistics';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeGreeting => 'Hello!';

  @override
  String get homeContinueLearning => 'Continue learning';

  @override
  String get homeReviewsToday => 'Due today';

  @override
  String get homeDailyGoal => 'Daily goal';

  @override
  String get homeProgress => 'Progress';

  @override
  String get homeStreak => 'Streak';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get errorNetwork => 'Unable to reach the server. Please try again.';

  @override
  String get errorUnknown => 'An unexpected error occurred.';

  @override
  String get errorUnauthorized => 'Please sign in again.';
}
