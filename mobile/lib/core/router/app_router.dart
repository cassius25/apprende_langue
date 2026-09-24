import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'route_names.dart';

/// Provider central du routeur GoRouter.
/// Les routes seront enrichies feature par feature (auth, learn, review, etc.).
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),

      // Placeholders : les features ajouteront leurs propres routes :
      // - /auth/login          (Partie 13)
      // - /onboarding          (Partie 13)
      // - /learn               (Partie 14)
      // - /review              (Partie 17)
      // - /statistics          (Partie 18)
      // - /profile             (Partie 18)
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: Center(child: Text('Route introuvable : ${state.uri}')),
    ),
  );
});
