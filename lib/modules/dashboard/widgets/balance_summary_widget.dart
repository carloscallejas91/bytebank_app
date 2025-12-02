import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app/utils/math_utils.dart';

class BalanceSummaryWidget extends StatelessWidget {
  final String formattedSelectedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onSelectMonth;
  final String formattedMonthlyNetResult;
  final double monthlyIncomeValue;
  final double monthlyExpensesValue;
  final NumberFormat currencyFormatter;

  const BalanceSummaryWidget({
    super.key,
    required this.formattedSelectedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onSelectMonth,
    required this.formattedMonthlyNetResult,
    required this.monthlyIncomeValue,
    required this.monthlyExpensesValue,
    required this.currencyFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMonthSelector(context),
            const SizedBox(height: 16),
            Text('Resultado do Mês', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              formattedMonthlyNetResult,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _financialProgressBar(
              theme: theme,
              label: 'Entrada',
              value: monthlyIncomeValue,
              percentage: MathUtils.calculatePercentage(
                monthlyIncomeValue,
                monthlyExpensesValue,
              ),
              color: Colors.green,
              currencyFormatter: currencyFormatter,
            ),
            const SizedBox(height: 24),
            _financialProgressBar(
              theme: theme,
              label: 'Saída',
              value: monthlyExpensesValue,
              percentage: MathUtils.calculatePercentage(
                monthlyExpensesValue,
                monthlyIncomeValue,
              ),
              color: theme.colorScheme.error,
              currencyFormatter: currencyFormatter,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: onPreviousMonth,
        ),
        InkWell(
          onTap: onSelectMonth,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              formattedSelectedMonth,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: onNextMonth,
        ),
      ],
    );
  }

  Widget _financialProgressBar({
    required ThemeData theme,
    required String label,
    required double value,
    required double percentage,
    required Color color,
    required NumberFormat currencyFormatter,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: color.withAlpha(50),
          ),
        ),
        const SizedBox(height: 4),
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
