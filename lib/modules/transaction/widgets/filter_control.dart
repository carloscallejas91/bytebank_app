import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterControl extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const FilterControl({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Text(label, style: Get.theme.textTheme.bodySmall),
            const SizedBox(width: 4),
            const Icon(Icons.calendar_month_outlined, size: 16),
          ],
        ),
      ),
    );
  }
}