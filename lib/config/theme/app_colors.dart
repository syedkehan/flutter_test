import 'package:flutter/material.dart';

/// App Colors - Centralized color definitions
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0F766E);
  static const Color primaryLight = Color(0xFF14B8A6);
  static const Color primaryDark = Color(0xFF115E59);
  static const Color surface = Color(0xFFF0FDFA);
  static const Color error = Color(0xFFDC2626);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    secondary: primaryLight,
    surface: surface,
    onSurface: textPrimary,
    error: error,
  );

  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.dark,
    primary: primaryLight,
    secondary: primary,
  );
}

final Color textColor = AppColors.textPrimary;
