import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary
  Color get primary;
  Color get primaryLight;

  // Background Gradient
  Color get backgroundLeft;
  Color get backgroundRight;

  // Secondary
  Color get secondary;

  // Text
  Color get textPrimary;
  Color get textWhite;
  Color get textGrey;
  Color get textBlack;
  Color get textHint;

  // Button
  Color get buttonColor;
  Color get buttonTextColor;

  // Container
  Color get containerWhite;

  // Status
  Color get success;
  Color get error;
  Color get pending;

  // Other
  Color get labelText;
  Color get hintText;

  Color get onboarding;
  Color get bottomBar;
}

class AppThemeColors extends AppColors {
  // Primary
  @override
  Color get primary => const Color(0xFF2563EB);

  @override
  Color get primaryLight => const Color(0xFF2460E3);

  // Background Gradient
  @override
  Color get backgroundLeft => const Color(0xFF1F427D);

  @override
  Color get backgroundRight => const Color(0xFF2460E3);

  // Secondary
  @override
  Color get secondary => const Color(0xFF32343E);

  // Text
  @override
  Color get textPrimary => const Color(0xFF262626);

  @override
  Color get textWhite => const Color(0xFFFFFFFF);

  @override
  Color get textGrey => const Color(0xFF646982);

  @override
  Color get textBlack => const Color(0xFF000000);

  @override
  Color get textHint => const Color(0xFFA0A5BA);

  // Button
  @override
  Color get buttonColor => const Color(0xFF2563EB);

  @override
  Color get buttonTextColor => const Color(0xFFFFFFFF);

  // Container
  @override
  Color get containerWhite => const Color(0xFFFFFFFF);

  // Status
  @override
  Color get success => const Color(0xFF6EEA53);

  @override
  Color get error => const Color(0xFFFF2929);

  @override
  Color get pending => const Color(0xFFEFBA2C);

  // Other
  @override
  Color get labelText => const Color(0xFF32343E);

  @override
  Color get hintText => const Color(0xFF646982);

  @override
  Color get onboarding => const Color(0xFF646982);

  @override
  Color get bottomBar => const Color(0xFF0F172A);
}
