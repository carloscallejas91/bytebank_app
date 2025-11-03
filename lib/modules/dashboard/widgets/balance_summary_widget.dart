import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/modules/dashboard/controllers/dashboard_controller.dart';

class BalanceSummaryWidget extends StatelessWidget {
  final DashboardController controller;

  const BalanceSummaryWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final currencyFormatter = NumberFormat.currency(
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
            _buildMonthSelector(context),
            const SizedBox(height: 16),
            Text('Resultado do Mês', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                controller.formattedMonthlyNetResult.value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Obx(
              () => _financialProgressBar(
                label: 'Entrada',
                value: controller.monthlyIncome.value,
                percentage: controller.calculatePercentage(
                  controller.monthlyIncome.value,
                  controller.monthlyExpenses.value,
                ),
                color: Colors.green,
                currencyFormatter: currencyFormatter,
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => _financialProgressBar(
                label: 'Saída',
                value: controller.monthlyExpenses.value,
                percentage: controller.calculatePercentage(
                  controller.monthlyExpenses.value,
                  controller.monthlyIncome.value,
                ),
                color: theme.colorScheme.error,
                currencyFormatter: currencyFormatter,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: controller.goToPreviousMonth,
        ),
        InkWell(
          onTap: () => controller.selectMonth(context),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Obx(
              () => Text(
                controller.formattedSelectedMonth.value,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: controller.goToNextMonth,
        ),
      ],
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
