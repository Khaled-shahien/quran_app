import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.lightPrimary,
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.white,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.white,
      surface: AppColors.lightBackground,
      onSurface: AppColors.primaryText,
      error: AppColors.error,
      onError: AppColors.white,
      outline: AppColors.lightSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      textTheme: _buildLightTextTheme(),
      appBarTheme: _buildAppBarTheme(
        primaryColor: AppColors.lightPrimary,
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.primaryText,
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.white,
        borderColor: AppColors.lightPrimary,
      ),
      outlinedButtonTheme: _buildOutlinedButtonTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightPrimary,
        borderColor: AppColors.lightPrimary,
      ),
      cardTheme: _buildCardThemeData(
        backgroundColor: AppColors.lightCardContent,
        surfaceTintColor: AppColors.lightCardContent,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
    );
  }

  static ThemeData get darkTheme {
    ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.darkPrimary,
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.black,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.white,
      surface: AppColors.darkBackground,
      onSurface: AppColors.white,
      error: AppColors.error,
      onError: AppColors.black,
      outline: AppColors.darkSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      textTheme: _buildDarkTextTheme(),
      appBarTheme: _buildAppBarTheme(
        primaryColor: AppColors.darkPrimary,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.white,
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.black,
        borderColor: AppColors.darkPrimary,
      ),
      outlinedButtonTheme: _buildOutlinedButtonTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkPrimary,
        borderColor: AppColors.darkPageAccent,
      ),
      cardTheme: _buildCardThemeData(
        backgroundColor: AppColors.darkCardContent,
        surfaceTintColor: AppColors.darkCardContent,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
    );
  }

  static TextTheme _buildLightTextTheme() {
    return TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(
        color: AppColors.primaryText,
      ),
      displayMedium: AppTypography.displayMedium.copyWith(
        color: AppColors.primaryText,
      ),
      displaySmall: AppTypography.displaySmall.copyWith(
        color: AppColors.primaryText,
      ),
      headlineLarge: AppTypography.headlineLarge.copyWith(
        color: AppColors.primaryText,
      ),
      headlineMedium: AppTypography.headlineMedium.copyWith(
        color: AppColors.primaryText,
      ),
      headlineSmall: AppTypography.headlineSmall.copyWith(
        color: AppColors.primaryText,
      ),
      titleLarge: AppTypography.titleLarge.copyWith(
        color: AppColors.primaryText,
      ),
      titleMedium: AppTypography.titleMedium.copyWith(
        color: AppColors.primaryText,
      ),
      titleSmall: AppTypography.titleSmall.copyWith(
        color: AppColors.primaryText,
      ),
      bodyLarge: AppTypography.bodyLarge.copyWith(
        color: AppColors.secondaryText,
      ),
      bodyMedium: AppTypography.bodyMedium.copyWith(
        color: AppColors.secondaryText,
      ),
      bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.captions),
      labelLarge: AppTypography.labelLarge.copyWith(
        color: AppColors.primaryText,
      ),
      labelMedium: AppTypography.labelMedium.copyWith(
        color: AppColors.primaryText,
      ),
      labelSmall: AppTypography.labelSmall.copyWith(
        color: AppColors.primaryText,
      ),
    );
  }

  static TextTheme _buildDarkTextTheme() {
    return TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.white),
      displayMedium: AppTypography.displayMedium.copyWith(
        color: AppColors.white,
      ),
      displaySmall: AppTypography.displaySmall.copyWith(color: AppColors.white),
      headlineLarge: AppTypography.headlineLarge.copyWith(
        color: AppColors.white,
      ),
      headlineMedium: AppTypography.headlineMedium.copyWith(
        color: AppColors.white,
      ),
      headlineSmall: AppTypography.headlineSmall.copyWith(
        color: AppColors.white,
      ),
      titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.white),
      titleMedium: AppTypography.titleMedium.copyWith(color: AppColors.white),
      titleSmall: AppTypography.titleSmall.copyWith(color: AppColors.white),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.lightGray),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.lightGray),
      bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.gray),
      labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.white),
      labelMedium: AppTypography.labelMedium.copyWith(color: AppColors.white),
      labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.white),
    );
  }

  static AppBarTheme _buildAppBarTheme({
    required Color primaryColor,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      titleTextStyle: AppTypography.titleLarge.copyWith(color: foregroundColor),
      elevation: 0,
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme({
    required Color backgroundColor,
    required Color foregroundColor,
    required Color borderColor,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        textStyle: AppTypography.titleMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme({
    required Color backgroundColor,
    required Color foregroundColor,
    required Color borderColor,
  }) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        textStyle: AppTypography.titleMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(color: borderColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static CardThemeData _buildCardThemeData({
    required Color backgroundColor,
    required Color surfaceTintColor,
  }) {
    return CardThemeData(
      color: backgroundColor,
      surfaceTintColor: surfaceTintColor,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    );
  }
}
