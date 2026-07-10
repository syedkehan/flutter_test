import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App Text Styles - Centralized typography definitions
const String outfit = 'Outfit'; //default
const String urbanist = 'Urbanist';

class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  static TextStyle _style(double size, FontWeight weight) =>
      TextStyle(fontSize: size.sp, fontWeight: weight, fontFamily: outfit);

  // Weight 400 -> sizes: 18, 14, 12, 10
  static TextStyle get w400_18 => _style(18, FontWeight.w400);
  static TextStyle get w400_16 => _style(16, FontWeight.w400);
  static TextStyle get w400_14 => _style(14, FontWeight.w400);
  static TextStyle get w400_12 => _style(12, FontWeight.w400);
  static TextStyle get w400_10 => _style(10, FontWeight.w400);

  // Weight 500 -> sizes: 24, 20, 16, 14, 12, 11, 10
  static TextStyle get w500_24 => _style(24, FontWeight.w500);
  static TextStyle get w500_20 => _style(20, FontWeight.w500);
  static TextStyle get w500_18 => _style(18, FontWeight.w500);
  static TextStyle get w500_16 => _style(16, FontWeight.w500);
  static TextStyle get w500_14 => _style(14, FontWeight.w500);
  static TextStyle get w500_12 => _style(12, FontWeight.w500);
  static TextStyle get w500_11 => _style(11, FontWeight.w500);
  static TextStyle get w500_10 => _style(10, FontWeight.w500);

  // Weight 600 -> sizes: 28, 26, 18, 16, 14, 12
  static TextStyle get w600_28 => _style(28, FontWeight.w600);
  static TextStyle get w600_22 => _style(22, FontWeight.w600);
  static TextStyle get w600_26 => _style(26, FontWeight.w600);
  static TextStyle get w600_18 => _style(18, FontWeight.w600);
  static TextStyle get w600_16 => _style(16, FontWeight.w600);
  static TextStyle get w600_14 => _style(14, FontWeight.w600);
  static TextStyle get w600_12 => _style(12, FontWeight.w600);
  static TextStyle get w600_10 => _style(12, FontWeight.w600);

  // Weight 700 -> sizes: 38, 30, 28
  static TextStyle get w700_38 => _style(38, FontWeight.w700);
  static TextStyle get w700_32 => _style(32, FontWeight.w700);
  static TextStyle get w700_30 => _style(30, FontWeight.w700);
  static TextStyle get w700_28 => _style(28, FontWeight.w700);
  static TextStyle get w700_24 => _style(24, FontWeight.w700);
  static TextStyle get w700_20 => _style(20, FontWeight.w700);
  static TextStyle get w700_18 => _style(18, FontWeight.w700);
  static TextStyle get w700_16 => _style(16, FontWeight.w700);
  static TextStyle get w700_14 => _style(14, FontWeight.w700);
  static TextStyle get w700_12 => _style(12, FontWeight.w700);

  // Display Styles
  static TextStyle get displayLarge => w700_38;

  static TextStyle get displayMedium => w700_30;

  static TextStyle get displaySmall => w700_28;

  // Headline Styles
  static TextStyle get headlineLarge => w600_28;

  static TextStyle get headlineMedium => w600_26;

  static TextStyle get headlineSmall => w500_24;

  // Title Styles
  static TextStyle get titleLarge => w500_20;

  static TextStyle get titleMedium => w500_16;

  static TextStyle get titleSmall => w500_14;

  // Body Styles
  static TextStyle get bodyLarge => w400_18;

  static TextStyle get bodyMedium => w400_14;

  static TextStyle get bodySmall => w400_12;

  // Label Styles
  static TextStyle get labelLarge => w500_12;

  static TextStyle get labelMedium => w500_11;

  static TextStyle get labelSmall => w500_10;

  /// Get the complete TextTheme
  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
