import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkEditorTheme {
    return ThemeData.dark().copyWith(
      primaryColor: AppColors.primaryPurple,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardColor: AppColors.cardDark,
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.accentGreen,
        inactiveTrackColor: Colors.white24,
        thumbColor: AppColors.accentGreen,
        overlayColor: AppColors.accentGreen.withOpacity(0.2),
        valueIndicatorTextStyle: const TextStyle(color: Colors.white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.accentGreen
              : Colors.grey,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.accentGreen.withOpacity(0.4)
              : Colors.white12,
        ),
      ),
    );
  }
}
