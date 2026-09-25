class RouteNames {
  const RouteNames._();

  static const String splash = 'splash';
  static const String home = 'home';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';

  static const String learn = 'learn';
  static const String review = 'review';
  static const String statistics = 'statistics';
  static const String profile = 'profile';

  static const String languages = 'languages';
  static const String vocabulary = 'vocabulary';
  static const String vocabularyDetail = 'vocabulary-detail';
  static const String flashcards = 'flashcards';
  static const String courses = 'courses';
  static const String courseDetail = 'course-detail';
  static const String lesson = 'lesson';

  static const String exerciseSession = 'exercise-session';
  static const String reviewHome = 'review-home';
  static const String reviewSession = 'review-session';

  // Onboarding
  static const String onboardingWelcome = 'onboarding-welcome';
  static const String onboardingNative = 'onboarding-native';
  static const String onboardingLearning = 'onboarding-learning';
  static const String onboardingLevel = 'onboarding-level';
  static const String onboardingGoal = 'onboarding-goal';
  static const String onboardingTime = 'onboarding-time';
  static const String onboardingAccount = 'onboarding-account';

  static const String goals = 'goals';
  static const String streak = 'streak';
  static const String badges = 'badges';
  static const String profileEdit = 'profile-edit';
  static const String profileChangePassword = 'profile-change-password';
  static const String profileDelete = 'profile-delete';
}

class RoutePaths {
  const RoutePaths._();

  static const String splash = '/';
  static const String home = '/home';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';

  static const String onboardingWelcome = '/onboarding';
  static const String onboardingNative = '/onboarding/native';
  static const String onboardingLearning = '/onboarding/learning';
  static const String onboardingLevel = '/onboarding/level';
  static const String onboardingGoal = '/onboarding/goal';
  static const String onboardingTime = '/onboarding/time';
  static const String onboardingAccount = '/onboarding/account';

  static const String learn = '/learn';
  static const String review = '/review';
  static const String statistics = '/statistics';
  static const String profile = '/profile';

  static const String languages = '/learn/languages';
  static const String courses = '/learn/courses';
  static const String vocabulary = '/learn/vocabulary';
  static const String flashcards = '/learn/flashcards';

  static String courseDetailFor(String id) => '/learn/courses/$id';
  static String lessonFor(String id) => '/learn/lessons/$id';
  static String vocabularyDetailFor(String id) => '/learn/vocabulary/$id';
  static String exerciseSessionFor(String lessonId) =>
      '/learn/lessons/$lessonId/exercises';

  static const String goals = '/goals';
  static const String streak = '/profile/streak';
  static const String badges = '/profile/badges';
  static const String profileEdit = '/profile/edit';
  static const String profileChangePassword = '/profile/change-password';
  static const String profileDelete = '/profile/delete';
}
