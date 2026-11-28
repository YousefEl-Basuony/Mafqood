import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Material 3 Light and Dark themes for Mafqood using Cairo typography.
class AppTheme {
  const AppTheme._();

  static ThemeData lightTheme() {
    final cairoFamily = GoogleFonts.cairo().fontFamily;
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: cairoFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.turquoise,
        brightness: Brightness.light,
        primary: AppColors.navyPrimary,
        onPrimary: Colors.white,
        secondary: AppColors.turquoiseDark,
        onSecondary: Colors.white,
        surface: AppColors.lightSurface,
        onSurface: AppColors.textDarkPrimary,
        error: AppColors.lostRed,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
    );

    final textTheme = base.textTheme.apply(
      fontFamily: cairoFamily,
      bodyColor: AppColors.textDarkPrimary,
      displayColor: AppColors.textDarkPrimary,
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.textDarkPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textDarkPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.turquoiseDark,
            width: 1.6,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navyPrimary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.lightSurfaceVariant,
        selectedColor: AppColors.turquoiseDark.withValues(alpha: 0.16),
        labelStyle: textTheme.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData darkTheme() {
    final cairoFamily = GoogleFonts.cairo().fontFamily;
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: cairoFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.turquoise,
        brightness: Brightness.dark,
        primary: AppColors.turquoise,
        onPrimary: AppColors.navyDeep,
        secondary: AppColors.turquoiseLight,
        onSecondary: AppColors.navyDeep,
        surface: AppColors.navySurface,
        onSurface: AppColors.textLightPrimary,
        error: AppColors.lostRed,
      ),
      scaffoldBackgroundColor: AppColors.navyDeep,
    );

    final textTheme = base.textTheme.apply(
      fontFamily: cairoFamily,
      bodyColor: AppColors.textLightPrimary,
      displayColor: AppColors.textLightPrimary,
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.navyDeep,
        foregroundColor: AppColors.textLightPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textLightPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.navySurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.navySurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.turquoise, width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.turquoise,
          foregroundColor: AppColors.navyDeep,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.navySurface,
        selectedColor: AppColors.turquoise.withValues(alpha: 0.24),
        labelStyle: textTheme.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
