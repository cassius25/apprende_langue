import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:langapp/features/exercises/presentation/pages/exercise_session_page.dart';
import 'package:langapp/features/goals/presentation/pages/goals_page.dart';
import 'package:langapp/features/profile/presentation/pages/badges_page.dart';
import 'package:langapp/features/profile/presentation/pages/change_password_page.dart';
import 'package:langapp/features/profile/presentation/pages/delete_account_page.dart';
import 'package:langapp/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:langapp/features/profile/presentation/pages/profile_page.dart';
import 'package:langapp/features/review/presentation/pages/review_home_page.dart';
import 'package:langapp/features/review/presentation/pages/review_session_page.dart';
import 'package:langapp/features/statistics/presentation/pages/statistics_page.dart';
import 'package:langapp/features/streak/presentation/pages/streak_page.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/courses/presentation/pages/course_detail_page.dart';
import '../../features/courses/presentation/pages/courses_page.dart';
import '../../features/flashcards/presentation/pages/flashcards_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/languages/presentation/pages/languages_page.dart';
import '../../features/lessons/presentation/pages/lesson_page.dart';
import '../../features/onboarding/presentation/pages/account_page.dart';
import '../../features/onboarding/presentation/pages/goal_page.dart';
import '../../features/onboarding/presentation/pages/learning_language_page.dart';
import '../../features/onboarding/presentation/pages/level_page.dart';
import '../../features/onboarding/presentation/pages/native_language_page.dart';
import '../../features/onboarding/presentation/pages/time_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/shell/presentation/pages/main_shell_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/vocabulary/presentation/pages/vocabulary_detail_page.dart';
import '../../features/vocabulary/presentation/pages/vocabulary_list_page.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen<AuthState>(authControllerProvider, (_, __) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final location = state.matchedLocation;
      final isSplash = location == RoutePaths.splash;
      final isAuthRoute = location.startsWith('/auth/');
      final isOnboarding = location.startsWith('/onboarding');

      if (auth.status == AuthStatus.unknown) {
        return isSplash ? null : RoutePaths.splash;
      }
      if (auth.status == AuthStatus.authenticated) {
        if (isSplash || isAuthRoute || isOnboarding) return RoutePaths.home;
        return null;
      }
      // Non authentifié → onboarding + auth autorisés
      if (isAuthRoute || isOnboarding) return null;
      return RoutePaths.login;
    },
    routes: [
      // ─── Splash ─────────────────────────────────────
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (_, __) => const SplashPage(),
      ),

      // ─── Auth ───────────────────────────────────────
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (_, __) => const RegisterPage(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (_, __) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/auth/reset-password',
        builder: (_, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return ResetPasswordPage(token: token);
        },
      ),
      GoRoute(
        path: '/auth/verify-email',
        builder: (_, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return VerifyEmailPage(token: token);
        },
      ),

      // ─── Onboarding ─────────────────────────────────
      GoRoute(
        path: RoutePaths.onboardingWelcome,
        name: RouteNames.onboardingWelcome,
        builder: (_, __) => const WelcomePage(),
      ),
      GoRoute(
        path: RoutePaths.onboardingNative,
        name: RouteNames.onboardingNative,
        builder: (_, __) => const NativeLanguagePage(),
      ),
      GoRoute(
        path: RoutePaths.onboardingLearning,
        name: RouteNames.onboardingLearning,
        builder: (_, __) => const LearningLanguagePage(),
      ),
      GoRoute(
        path: RoutePaths.onboardingLevel,
        name: RouteNames.onboardingLevel,
        builder: (_, __) => const LevelPage(),
      ),
      GoRoute(
        path: RoutePaths.onboardingGoal,
        name: RouteNames.onboardingGoal,
        builder: (_, __) => const GoalPage(),
      ),
      GoRoute(
        path: RoutePaths.onboardingTime,
        name: RouteNames.onboardingTime,
        builder: (_, __) => const TimePage(),
      ),
      GoRoute(
        path: RoutePaths.onboardingAccount,
        name: RouteNames.onboardingAccount,
        builder: (_, __) => const AccountPage(),
      ),

      // ─── Shell principal ────────────────────────────
      ShellRoute(
        builder: (context, state, child) {
          final location = state.uri.toString();
          int index = 0;
          if (location.startsWith('/learn')) {
            index = 1;
          } else if (location.startsWith('/review')) {
            index = 2;
          } else if (location.startsWith('/statistics')) {
            index = 3;
          } else if (location.startsWith('/profile')) {
            index = 4;
          }
          return MainShellPage(currentIndex: index, child: child);
        },
        routes: [
          GoRoute(
            path: RoutePaths.home,
            name: RouteNames.home,
            builder: (_, __) => const HomePage(),
          ),

          // ─── Learn ─────────────────────────────────
          GoRoute(
            path: RoutePaths.learn,
            name: RouteNames.learn,
            redirect: (_, __) => RoutePaths.languages,
            routes: [
              GoRoute(
                path: 'languages',
                name: RouteNames.languages,
                builder: (_, __) => const LanguagesPage(),
              ),
              GoRoute(
                path: 'courses',
                name: RouteNames.courses,
                builder: (_, state) => CoursesPage(
                  languageId: state.uri.queryParameters['languageId'],
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: RouteNames.courseDetail,
                    builder: (_, state) =>
                        CourseDetailPage(courseId: state.pathParameters['id']!),
                  ),
                ],
              ),
              GoRoute(
                path: 'lessons/:id',
                name: RouteNames.lesson,
                builder: (_, state) =>
                    LessonPage(lessonId: state.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'exercises',
                    name: RouteNames.exerciseSession,
                    builder: (_, state) => ExerciseSessionPage(
                      lessonId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'vocabulary',
                name: RouteNames.vocabulary,
                builder: (_, __) => const VocabularyListPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: RouteNames.vocabularyDetail,
                    builder: (_, state) => VocabularyDetailPage(
                      vocabularyId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'flashcards',
                name: RouteNames.flashcards,
                builder: (_, __) => const FlashcardsPage(),
              ),
            ],
          ),

          // ─── Review ───────────────────────────────
          GoRoute(
            path: RoutePaths.review,
            name: RouteNames.reviewHome,
            builder: (_, __) => const ReviewHomePage(),
            routes: [
              GoRoute(
                path: 'session',
                name: RouteNames.reviewSession,
                builder: (_, __) => const ReviewSessionPage(),
              ),
            ],
          ),

          // ─── Statistics / Profile ─────────────────
          GoRoute(
            path: RoutePaths.statistics,
            name: RouteNames.statistics,
            builder: (_, __) => const StatisticsPage(),
          ),
          GoRoute(
            path: RoutePaths.profile,
            name: RouteNames.profile,
            builder: (_, __) => const ProfilePage(),
            routes: [
              GoRoute(
                path: 'edit',
                name: RouteNames.profileEdit,
                builder: (_, __) => const EditProfilePage(),
              ),
              GoRoute(
                path: 'streak',
                name: RouteNames.streak,
                builder: (_, __) => const StreakPage(),
              ),
              GoRoute(
                path: 'badges',
                name: RouteNames.badges,
                builder: (_, __) => const BadgesPage(),
              ),
              GoRoute(
                path: 'change-password',
                name: RouteNames.profileChangePassword,
                builder: (_, __) => const ChangePasswordPage(),
              ),
              GoRoute(
                path: 'delete',
                name: RouteNames.profileDelete,
                builder: (_, __) => const DeleteAccountPage(),
              ),
            ],
          ),

          GoRoute(
            path: RoutePaths.goals,
            name: RouteNames.goals,
            builder: (_, __) => const GoalsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: Center(child: Text('Route introuvable : ${state.uri}')),
    ),
  );
});
