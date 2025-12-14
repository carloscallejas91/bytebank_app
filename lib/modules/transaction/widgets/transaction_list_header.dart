import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/domain/enums/sort_order.dart';

class TransactionListHeader extends StatelessWidget {
  final String titleText;
  final SortOrder sortOrder;
  final VoidCallback onToggleSortOrder;

  const TransactionListHeader({
    super.key,
    required this.titleText,
    required this.sortOrder,
    required this.onToggleSortOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(titleText, style: Get.theme.textTheme.titleMedium),
        _buildSortControl(),
      ],
    );
  }

  InkWell _buildSortControl() {
    return InkWell(
      onTap: onToggleSortOrder,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Text('Ordenar por data:', style: Get.theme.textTheme.bodySmall),
            const SizedBox(width: 4),
            Icon(
              sortOrder == SortOrder.desc
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
