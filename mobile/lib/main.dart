import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_env.dart';
import 'core/providers/core_providers.dart';
import 'core/storage/preferences.dart';
import 'core/utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  AppLogger.i('Starting LangApp — env: ${AppConfig.environment.name}');
  AppLogger.i('API base URL: ${AppConfig.apiBaseUrl}');

  // Charge les préférences avant le démarrage.
  final prefs = await AppPreferences.load();

  runApp(
    ProviderScope(
      overrides: [
        // Rend AppPreferences disponible partout.
        appPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const LangApp(),
    ),
  );
}
