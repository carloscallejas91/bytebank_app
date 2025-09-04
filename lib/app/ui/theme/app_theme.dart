import 'package:flutter/material.dart';
import 'package:mobile_app/app/ui/theme/app_color_extensions.dart';

import 'app_colors.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightTextPrimary,
    error: AppColors.error,
    onError: AppColors.onError,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
  ),
  scaffoldBackgroundColor: AppColors.lightBackground,
  cardTheme: const CardThemeData(
    color: AppColors.lightSurface,
    elevation: 2,
    shadowColor: Color(0x1A64748B),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.onSecondary,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.secondary,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: AppColors.lightTextPrimary),
    hintStyle: TextStyle(color: AppColors.lightTextPrimary),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.lightBorder),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.lightBorder),
    ),
  ),
  extensions: const <ThemeExtension<dynamic>>[
    AppColorExtensions(
      onSuccess: AppColors.success,
      success: AppColors.onSuccess,
      warning: AppColors.warning,
      onWarning: AppColors.onWarning,
    ),
  ],
);
