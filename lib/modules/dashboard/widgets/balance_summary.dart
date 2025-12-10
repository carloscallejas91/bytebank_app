import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app/utils/math_utils.dart';

class BalanceSummary extends StatelessWidget {
  final String monthlyNetResultLabel;
  final String incomeLabel;
  final String expensesLabel;
  final String formattedSelectedMonth;
  final Function() onPreviousMonth;
  final Function() onNextMonth;
  final Function() onSelectMonth;
  final String formattedMonthlyNetResult;
  final double monthlyIncomeValue;
  final double monthlyExpensesValue;
  final NumberFormat currencyFormatter;

  const BalanceSummary({
    super.key,
    required this.monthlyNetResultLabel,
    required this.incomeLabel,
    required this.expensesLabel,
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
    return Card(
      margin: EdgeInsets.zero,
      color: Get.theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMonthSelector(),
            const SizedBox(height: 16),
            buildSummary(),
            buildDivider(),
            _buildFinancialProgressBar(
              label: incomeLabel,
              value: monthlyIncomeValue,
              percentage: MathUtils.calculatePercentage(
                monthlyIncomeValue,
                monthlyExpensesValue,
              ),
              color: Colors.green,
              currencyFormatter: currencyFormatter,
            ),
            const SizedBox(height: 24),
            _buildFinancialProgressBar(
              label: expensesLabel,
              value: monthlyExpensesValue,
              percentage: MathUtils.calculatePercentage(
                monthlyExpensesValue,
                monthlyIncomeValue,
              ),
              color: Get.theme.colorScheme.error,
              currencyFormatter: currencyFormatter,
            ),
          ],
        ),
      ),
    );
  }

  Row _buildMonthSelector() {
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
              style: Get.theme.textTheme.titleMedium,
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

  Column buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(monthlyNetResultLabel, style: Get.theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          formattedMonthlyNetResult,
          style: Get.theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Column buildDivider() {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFinancialProgressBar({
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
            Text(label, style: Get.theme.textTheme.bodyLarge),
            Text(
              currencyFormatter.format(value),
              style: Get.theme.textTheme.bodyLarge?.copyWith(
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
            style: Get.theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
