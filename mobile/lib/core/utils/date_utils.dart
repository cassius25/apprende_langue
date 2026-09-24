import 'package:intl/intl.dart';

class AppDateUtils {
  const AppDateUtils._();

  /// Aujourd'hui à minuit UTC (clé de jour utilisée par le backend).
  static DateTime todayUtc() {
    final now = DateTime.now().toUtc();
    return DateTime.utc(now.year, now.month, now.day);
  }

  /// Clé `YYYY-MM-DD`.
  static String dayKey(DateTime d) =>
      d.toUtc().toIso8601String().substring(0, 10);

  /// Parse ISO → DateTime local (safe).
  static DateTime? tryParseIso(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw)?.toLocal();
  }

  /// Date absolue lisible : "15 janv. 2025".
  static String formatShort(DateTime? d, {String locale = 'fr'}) {
    if (d == null) return '';
    return DateFormat.yMMMd(locale).format(d);
  }

  /// Date + heure : "15 janv. 2025, 14:30".
  static String formatShortDateTime(DateTime? d, {String locale = 'fr'}) {
    if (d == null) return '';
    return DateFormat.yMMMd(locale).add_Hm().format(d);
  }

  /// "il y a 3 min", "il y a 2 h", "hier", "il y a 5 j".
  static String timeAgo(DateTime? date, {String locale = 'fr'}) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'à l’instant';
    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'il y a ${diff.inHours} h';
    if (diff.inDays == 1) return 'hier';
    if (diff.inDays < 30) return 'il y a ${diff.inDays} j';
    if (diff.inDays < 365) return 'il y a ${(diff.inDays / 30).floor()} mois';
    return 'il y a ${(diff.inDays / 365).floor()} an(s)';
  }

  /// Libellé court d'un jour de la semaine : "L", "M", "M", "J", "V", "S", "D".
  static String weekdayInitial(DateTime d) {
    const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    return days[(d.weekday - 1) % 7];
  }

  /// `true` si `d` est aujourd'hui (UTC).
  static bool isToday(DateTime d) {
    final today = todayUtc();
    return d.toUtc().year == today.year &&
        d.toUtc().month == today.month &&
        d.toUtc().day == today.day;
  }
}
