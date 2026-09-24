import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../config/app_env.dart';

final _logger = Logger(
  filter: kReleaseMode ? ProductionFilter() : DevelopmentFilter(),
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 6,
    lineLength: 100,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
  level: AppConfig.isDev ? Level.debug : Level.info,
);

class AppLogger {
  const AppLogger._();

  static void d(Object? message, {Object? error, StackTrace? stack}) {
    _logger.d(message, error: error, stackTrace: stack);
  }

  static void i(Object? message, {Object? error, StackTrace? stack}) {
    _logger.i(message, error: error, stackTrace: stack);
  }

  static void w(Object? message, {Object? error, StackTrace? stack}) {
    _logger.w(message, error: error, stackTrace: stack);
  }

  static void e(Object? message, {Object? error, StackTrace? stack}) {
    _logger.e(message, error: error, stackTrace: stack);
  }
}
