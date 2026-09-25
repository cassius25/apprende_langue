import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_env.dart';
import 'core/providers/core_providers.dart';
import 'core/storage/drift/app_database.dart';
import 'core/storage/drift/providers.dart';
import 'core/storage/preferences.dart';
import 'core/utils/logger.dart';
import 'features/auth/presentation/providers/auth_controller.dart';

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

  final prefs = await AppPreferences.load();
  final database = AppDatabase();
  await database.syncQueueDao.resetInFlight();
  await database.purgeSyncedEntries();

  runApp(
    ProviderScope(
      overrides: [
        appPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(database),
        onSessionExpiredProvider.overrideWith(
          (ref) =>
              () => ref
                  .read(authControllerProvider.notifier)
                  .handleSessionExpired(),
        ),
      ],
      child: const LangApp(),
    ),
  );
}
