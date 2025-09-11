import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BalanceSummaryWidget extends StatelessWidget {
  final double total;
  final double income;
  final double expenses;

  const BalanceSummaryWidget({
    super.key,
    required this.total,
    required this.income,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Valor Total em Conta', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              currencyFormatter.format(total),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _financialProgressBar(
              label: 'Entrada',
              value: income,
              percentage: total > 0 ? income / total : 0,
              color: Colors.green,
              currencyFormatter: currencyFormatter,
            ),
            const SizedBox(height: 24),
            _financialProgressBar(
              label: 'Saída',
              value: expenses,
              percentage: total > 0 ? expenses / total : 0,
              color: theme.colorScheme.error,
              currencyFormatter: currencyFormatter,
            ),
          ],
        ),
      ),
    );
  }

  Widget _financialProgressBar({
    required String label,
    required double value,
    required double percentage,
    required Color color,
    required NumberFormat currencyFormatter,
  }) {
    final theme = Theme.of(Get.context!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodyLarge),
            Text(
              currencyFormatter.format(value),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: color.withValues(alpha: 0.2),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${(percentage * 100).toStringAsFixed(1)}% do total',
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
