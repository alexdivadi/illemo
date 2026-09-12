import 'package:flutter/material.dart';
import 'package:illemo/src/theme/app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final theme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Avenir Next',
      fontFamilyFallback: const ['Nunito', 'Helvetica Neue', 'Arial', 'sans-serif'],
      colorSchemeSeed: AppColors.primary,
      unselectedWidgetColor: Colors.grey,
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.border,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.onPrimary,
        selectedColor: AppColors.chip,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
      ),
    );

    TextStyle? displayStyle(TextStyle? style) => style?.copyWith(
          fontFamily: 'Georgia',
          fontFamilyFallback: const ['DM Serif Display', 'Times New Roman', 'serif'],
          color: const Color(0xFF2D1F0E),
        );

    return theme.copyWith(
      textTheme: theme.textTheme.copyWith(
        displayLarge: displayStyle(theme.textTheme.displayLarge),
        displayMedium: displayStyle(theme.textTheme.displayMedium),
        displaySmall: displayStyle(theme.textTheme.displaySmall),
        headlineLarge: displayStyle(theme.textTheme.headlineLarge),
        headlineMedium: displayStyle(theme.textTheme.headlineMedium),
        headlineSmall: displayStyle(theme.textTheme.headlineSmall),
        titleLarge: displayStyle(theme.textTheme.titleLarge),
        titleMedium: displayStyle(theme.textTheme.titleMedium),
      ),
    );
  }

  static ThemeData get dark {
    final theme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Avenir Next',
      fontFamilyFallback: const ['Nunito', 'Helvetica Neue', 'Arial', 'sans-serif'],
      colorSchemeSeed: AppColors.chip,
      scaffoldBackgroundColor: const Color(0xFF17120D),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF17120D),
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );

    TextStyle? displayStyle(TextStyle? style) => style?.copyWith(
          fontFamily: 'Georgia',
          fontFamilyFallback: const ['DM Serif Display', 'Times New Roman', 'serif'],
          color: theme.colorScheme.onSurface,
        );

    return theme.copyWith(
      textTheme: theme.textTheme.copyWith(
        displayLarge: displayStyle(theme.textTheme.displayLarge),
        displayMedium: displayStyle(theme.textTheme.displayMedium),
        displaySmall: displayStyle(theme.textTheme.displaySmall),
        headlineLarge: displayStyle(theme.textTheme.headlineLarge),
        headlineMedium: displayStyle(theme.textTheme.headlineMedium),
        headlineSmall: displayStyle(theme.textTheme.headlineSmall),
        titleLarge: displayStyle(theme.textTheme.titleLarge),
        titleMedium: displayStyle(theme.textTheme.titleMedium),
      ),
    );
  }
}
