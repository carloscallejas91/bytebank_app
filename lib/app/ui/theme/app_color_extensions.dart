import 'package:flutter/material.dart';

@immutable
class AppColorExtensions extends ThemeExtension<AppColorExtensions> {
  const AppColorExtensions({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
  });

  final Color? success;
  final Color? onSuccess;
  final Color? warning;
  final Color? onWarning;

  @override
  AppColorExtensions copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? gradientPrimary,
    Color? gradientSecondary,
    Color? gradientTertiary,
  }) {
    return AppColorExtensions(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
    );
  }

  @override
  AppColorExtensions lerp(ThemeExtension<AppColorExtensions>? other, double t) {
    if (other is! AppColorExtensions) {
      return this;
    }
    return AppColorExtensions(
      success: Color.lerp(success, other.success, t),
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t),
      warning: Color.lerp(warning, other.warning, t),
      onWarning: Color.lerp(onWarning, other.onWarning, t),
    );
  }
}
