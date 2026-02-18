import 'package:flutter/material.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

class AppTextStyle {

  //-------------------------------Login/register/verification
  static TextStyle displayLarge(Color color, {String? fontFamily}) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: color,
      fontFamily: fontFamily,
    );
  }

  //-------------------------------Login/register/verification => small Text
  static TextStyle displayMedium(Color color,{String? fontFamily}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color,
      fontFamily: fontFamily,
    );
  }

  //-------------------------------Login/register/verification => small Text

  static TextStyle displaySmall(Color color, {String? fontFamily}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: color,
      fontFamily: fontFamily,
    );
  }

  //------------------------Button Text
  static TextStyle bodyLarge(Color color,{String? fontFamily}){
    return TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color,
        fontFamily: fontFamily
    );
  }

  /* --------------------------Form Field Text--------------------------*/
  static TextStyle bodyMedium(Color color,{String? fontFamily}) {
    return TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: color,
      fontFamily: fontFamily,
    );
  }

  /* --------------------------label Text--------------------------*/
  static TextStyle labelLarge(Color color,{String? fontFamily}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color,
      fontFamily: fontFamily,
    );
  }

  /* --------------------------Hint Text--------------------------*/
  static TextStyle labelMedium(Color color,{String? fontFamily}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color,
      fontFamily: fontFamily,
    );
  }

  //--------------------------------Onboarding
  static TextStyle headlineLarge(Color color,{String? fontFamily}) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: color,
      fontFamily: fontFamily,
    );
  }

  //--------------------------------Onboarding Paragraph

  static TextStyle headlineMedium(Color color,{String? fontFamily}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color,
      fontFamily: fontFamily,
    );
  }
}



class AppTextTheme {
  static TextTheme theme({String? fontFamily}) {
    final colors = AppThemeColors();

    return TextTheme(

      // 🔹 VERY LARGE (rarely used)
      displayLarge: AppTextStyle.headlineLarge(
        colors.textWhite,
        fontFamily: fontFamily,
      ),

      // 🔹 Page titles / section headers
      headlineLarge: AppTextStyle.displayLarge(
        colors.textPrimary,
        fontFamily: fontFamily,
      ),

      headlineMedium: AppTextStyle.displaySmall(
        colors.textPrimary,
        fontFamily: fontFamily,
      ),

      // 🔹 NORMAL TEXT (MOST IMPORTANT)
      bodyLarge: AppTextStyle.displayMedium(
        colors.textPrimary,
        fontFamily: fontFamily,
      ),

      bodyMedium: AppTextStyle.bodyMedium(
        colors.textPrimary,
        fontFamily: fontFamily,
      ),

      bodySmall: TextStyle(
        fontSize: 12,
        color: colors.textGrey,
        fontFamily: fontFamily,
      ),

      // 🔹 LABELS / HINTS
      labelLarge: AppTextStyle.labelLarge(
        colors.labelText,
        fontFamily: fontFamily,
      ),

      labelMedium: AppTextStyle.labelMedium(
        colors.hintText,
        fontFamily: fontFamily,
      ),
    );
  }
}
