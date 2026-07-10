import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_test_app/config/theme/app_colors.dart';
import 'package:flutter_test_app/config/theme/app_text_styles.dart';

// Theme
ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: AppColors.lightColorScheme,
  fontFamily: outfit,
  textTheme: AppTextStyles.textTheme,
  primaryTextTheme: AppTextStyles.textTheme,
  scaffoldBackgroundColor: Colors.white,

  // App Bar Theme
  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    backgroundColor: AppColors.lightColorScheme.surface,
    foregroundColor: AppColors.lightColorScheme.onSurface,
    surfaceTintColor: Colors.transparent,
    shadowColor: AppColors.lightColorScheme.shadow,
    toolbarHeight: 56.h,
    leadingWidth: 80.w,
    titleSpacing: 0,
    titleTextStyle: AppTextStyles.titleLarge.copyWith(
      fontWeight: FontWeight.w600,
      color: AppColors.lightColorScheme.onSurface,
    ),
    iconTheme: IconThemeData(
      color: AppColors.lightColorScheme.onSurface,
      size: 24.r,
    ),
    actionsIconTheme: IconThemeData(
      color: AppColors.lightColorScheme.onSurface,
      size: 24.r,
    ),
    systemOverlayStyle: const SystemUiOverlayStyle(
      // statusBarColor: Colors.transparent,
      // statusBarIconBrightness: Brightness.light,
      // statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark, // For iOS
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  ),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.lightColorScheme.primary,
      foregroundColor: AppColors.lightColorScheme.onPrimary,
      disabledBackgroundColor: AppColors.lightColorScheme.onSurface.withValues(
        alpha: 0.12,
      ),
      disabledForegroundColor: AppColors.lightColorScheme.onSurface.withValues(
        alpha: 0.38,
      ),
      minimumSize: Size(double.infinity.w, 56.h),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r)),
      textStyle: AppTextStyles.titleMedium,
      animationDuration: const Duration(milliseconds: 200),
    ),
  ),

  // Outlined Button Theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.lightColorScheme.primary,

      disabledForegroundColor: AppColors.lightColorScheme.onSurface.withValues(
        alpha: 0.38,
      ),
      side: BorderSide(color: AppColors.lightColorScheme.primary, width: 1.w),
      disabledBackgroundColor: Colors.transparent,
      minimumSize: Size(double.infinity.w, 56.h),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r)),
      textStyle: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
      animationDuration: const Duration(milliseconds: 200),
    ),
  ),

  // Text Button Theme
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.lightColorScheme.primary,
      disabledForegroundColor: AppColors.lightColorScheme.onSurface.withValues(
        alpha: 0.38,
      ),
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 8.h),
      minimumSize: Size(0, 48.h),
      textStyle: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600),
      animationDuration: const Duration(milliseconds: 200),
    ),
  ),

  // Icon Button Theme
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      backgroundColor: AppColors.surface,
      padding: EdgeInsets.zero,
      minimumSize: Size(40.w, 40.h),
      shape: const CircleBorder(),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),

    // Border styles
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide.none,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide.none,
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide.none,
    ),

    // Typography
    labelStyle: AppTextStyles.bodyMedium.copyWith(
      color: const Color(0xff7883A0),
    ),
    hintStyle: AppTextStyles.bodyMedium.copyWith(
      color: const Color(0xff7883A0),
    ),
    errorStyle: AppTextStyles.bodySmall.copyWith(color: Colors.red),
    helperStyle: AppTextStyles.bodySmall.copyWith(
      color: const Color(0xff7883A0),
    ),

    // Behavior
    floatingLabelBehavior: FloatingLabelBehavior.never,
    alignLabelWithHint: true,
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 0,
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.lightColorScheme.primary,
    unselectedItemColor: const Color(0xff5A6274),
    selectedLabelStyle: AppTextStyles.titleSmall.copyWith(
      color: AppColors.lightColorScheme.primary,
      fontFamily: urbanist,
    ),
    unselectedLabelStyle: AppTextStyles.titleSmall.copyWith(
      color: const Color(0xff5A6274),
      fontFamily: urbanist,
    ),
  ),

  // Divider Theme
  dividerTheme: DividerThemeData(
    thickness: 1.w,
    space: 1.h,
    color: const Color(0xffF1F5F9),
  ),
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: AppColors.darkColorScheme,
  textTheme: AppTextStyles.textTheme,
  primaryTextTheme: AppTextStyles.textTheme,
);
