import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/ui/theme/app_color_extensions.dart';

class SnackBarService extends GetxService {
  ThemeData get _theme => Theme.of(Get.context!);

  AppColorExtensions get _customColors =>
      _theme.extension<AppColorExtensions>()!;

  void _showSnackBar({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color colorText,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: colorText,
    );
  }

  void showError({required String title, String? message}) {
    _showSnackBar(
      title: title,
      message: message ?? 'Ocorreu um erro, tente novamente mais tarde.',
      backgroundColor: _theme.colorScheme.error,
      colorText: _theme.colorScheme.onError,
    );
  }

  void showSuccess({required String title, required String message}) {
    _showSnackBar(
      title: title,
      message: message,
      backgroundColor: _customColors.success!,
      colorText: _customColors.onSuccess!,
    );
  }

  void showWarning({required String title, required String message}) {
    _showSnackBar(
      title: title,
      message: message,
      backgroundColor: _customColors.warning!,
      colorText: _customColors.onWarning!,
    );
  }
}
