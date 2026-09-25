class RouteNames {
  const RouteNames._();

  // Root
  static const String splash = 'splash';
  static const String home = 'home';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';

  // Onboarding
  static const String onboarding = 'onboarding';

  // Tabs (shell)
  static const String learn = 'learn';
  static const String review = 'review';
  static const String statistics = 'statistics';
  static const String profile = 'profile';

  // Content
  static const String languages = 'languages';
  static const String courses = 'courses';
  static const String lesson = 'lesson';
  static const String vocabulary = 'vocabulary';
  static const String flashcards = 'flashcards';
  static const String exercise = 'exercise';
}

class RoutePaths {
  const RoutePaths._();

  static const String splash = '/';
  static const String home = '/home';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';

  static const String onboarding = '/onboarding';

  static const String learn = '/learn';
  static const String review = '/review';
  static const String statistics = '/statistics';
  static const String profile = '/profile';

  static const String languages = '/learn/languages';
  static const String courses = '/learn/courses';
  static const String lesson = '/learn/lesson';
  static const String vocabulary = '/learn/vocabulary';
  static const String flashcards = '/learn/flashcards';
  static const String exercise = '/learn/exercise';
}
