import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  const AppTypography._();

  static TextTheme lightTextTheme(Color primaryText, Color secondaryText) {
    final base = GoogleFonts.interTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontWeight: FontWeight.w500,
        color: secondaryText,
      ),
      bodyLarge: base.bodyLarge?.copyWith(color: primaryText),
      bodyMedium: base.bodyMedium?.copyWith(color: primaryText),
      bodySmall: base.bodySmall?.copyWith(color: secondaryText),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      labelMedium: base.labelMedium?.copyWith(color: secondaryText),
      labelSmall: base.labelSmall?.copyWith(color: secondaryText),
    );
  }
}
