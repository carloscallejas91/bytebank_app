import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const DateFilterChip({
    super.key,
    required this.label,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      onDeleted: onDeleted,
      deleteIcon: Icon(
        Icons.close,
        size: 18,
        color: Get.theme.colorScheme.onSurface,
      ),
      backgroundColor: Get.theme.colorScheme.surface,
      labelStyle: TextStyle(color: Get.theme.colorScheme.onSurfaceVariant),
    );
  }
}