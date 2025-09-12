import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/ui/theme/app_color_extensions.dart';

class SnackBarService extends GetxService {
  void showError({required String title, String? message}) {
    final theme = Theme.of(Get.context!);

    Get.snackbar(
      title,
      message ?? 'Ocorreu um erro, tente novamente mais tarde.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: theme.colorScheme.error,
      colorText: theme.colorScheme.onError,
    );
  }

  void showSuccess({required String title, required String message}) {
    final customColors = Theme.of(Get.context!).extension<AppColorExtensions>()!;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: customColors.success,
      colorText: customColors.onSuccess,
    );
  }

  void showWarning({required String title, required String message}) {
    final customColors = Theme.of(Get.context!).extension<AppColorExtensions>()!;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: customColors.warning,
      colorText: customColors.onWarning,
    );
  }
}