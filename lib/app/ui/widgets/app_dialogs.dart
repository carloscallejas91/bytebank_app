import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialogs {
  static void showSuccessDialog({
    required String title,
    required String message,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    final theme = Theme.of(Get.context!);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: onConfirm ?? () => Get.back(),
            child: Text(
              confirmText ?? 'OK',
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static void showConfirmationDialog({
    required String title,
    required String message,
    String? confirmText,
    Color? confirmTextColor,
    required VoidCallback onConfirm,
    String? cancelText,
    Color? cancelTextColor,
    VoidCallback? onCancel,
  }) {
    final theme = Theme.of(Get.context!);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: onCancel ?? () => Get.back(),
            child: Text(
              cancelText ?? 'Cancelar',
              style: TextStyle(
                color: cancelTextColor ?? theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(
              confirmText ?? 'Confirmar',
              style: TextStyle(
                color: confirmTextColor ?? theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
