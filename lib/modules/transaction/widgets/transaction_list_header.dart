import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/domain/enums/sort_order.dart';

class TransactionListHeader extends StatelessWidget {
  final SortOrder sortOrder;
  final VoidCallback onToggleSortOrder;

  const TransactionListHeader({
    super.key,
    required this.sortOrder,
    required this.onToggleSortOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Lista de Transações', style: Get.theme.textTheme.titleMedium),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Data',
                  style: Get.theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    sortOrder == SortOrder.desc
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                  ),
                  tooltip: 'Alterar ordenação',
                  onPressed: onToggleSortOrder,
                ),
              ],
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
