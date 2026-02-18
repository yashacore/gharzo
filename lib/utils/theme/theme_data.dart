import 'package:flutter/material.dart';
import 'colors.dart';

class AppThemeData {
  static ThemeData gharZoTheme({String? fontFamily}) {
    final colors = AppThemeColors();

    return ThemeData(
      fontFamily: fontFamily,
      useMaterial3: false, // 🔥 IMPORTANT (explained below)

      primaryColor: colors.primary,
      scaffoldBackgroundColor: colors.containerWhite,

      colorScheme: ColorScheme.light(
        primary: colors.primary,
        onPrimary: colors.textWhite,
        secondary: colors.secondary,
        onSecondary: colors.textWhite,
        error: colors.error,
        onError: colors.textWhite,
        surface: colors.containerWhite,
        onSurface: colors.textPrimary,
      ),

      /// 🔥 TEXT THEME (THIS FIXES BIG TEXT)
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),

        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),

        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.buttonColor,
          foregroundColor: colors.buttonTextColor,
          minimumSize: const Size(327, 62),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Sen',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.containerWhite,
        hintStyle: TextStyle(
          color: colors.textHint,
          fontSize: 14,
        ),
        labelStyle: TextStyle(
          color: colors.secondary,
          fontSize: 13,
        ),
      ),
    );
  }
}
