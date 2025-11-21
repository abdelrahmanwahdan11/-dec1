import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/theme_controller.dart';

class AppThemeBuilder {
  static TextTheme textTheme(Locale locale) {
    final base = locale.languageCode == 'ar'
        ? GoogleFonts.cairoTextTheme()
        : GoogleFonts.poppinsTextTheme();
    return base.copyWith(
      headlineSmall: base.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      bodyMedium: base.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
      bodyLarge: base.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
    );
  }

  static ThemeData light(Locale locale, ThemeController controller) =>
      controller.lightTheme(textTheme(locale));
  static ThemeData dark(Locale locale, ThemeController controller) =>
      controller.darkTheme(textTheme(locale));
}
