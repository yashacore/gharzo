
import 'package:flutter/material.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

class CommonMethod {
  LinearGradient authBackgroundGradient() {
    final colors = AppThemeColors();

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        colors.backgroundLeft,
        colors.backgroundRight,
      ],
    );
  }

}