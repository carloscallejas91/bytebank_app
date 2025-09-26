import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CategorySummaryWidget extends StatelessWidget {
  final String title;
  final Map<String, double> spendingData;

  const CategorySummaryWidget({
    super.key,
    required this.title,
    required this.spendingData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final progressBarColors = [
      Colors.blueAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
      Colors.teal,
      Colors.redAccent,
      Colors.indigoAccent,
      Colors.greenAccent,
    ];

    final currencyFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    final processedCategories = _processSpendingData(spendingData);

    final totalSpending = spendingData.values.reduce((sum, item) => sum + item);

    final random = Random();

    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const Divider(),
            ...processedCategories.entries.map((entry) {
              final String category = entry.key;
              final double value = entry.value;
              final double percentage = totalSpending > 0
                  ? value / totalSpending
                  : 0;

              final Color barColor =
                  progressBarColors[random.nextInt(progressBarColors.length)];

              return _spendingCategoryRow(
                categoryName: category,
                value: value,
                percentage: percentage,
                currencyFormatter: currencyFormatter,
                barColor: barColor,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _spendingCategoryRow({
    required String categoryName,
    required double value,
    required double percentage,
    required NumberFormat currencyFormatter,
    required Color barColor,
  }) {
    final theme = Theme.of(Get.context!);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(categoryName, style: theme.textTheme.bodyLarge),
              Text(
                currencyFormatter.format(value),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
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
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              backgroundColor: barColor.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(percentage * 100).toStringAsFixed(1)}% do total de gastos',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

Map<String, double> _processSpendingData(Map<String, double> spendingData) {
  if (spendingData.isEmpty) return {};

  final double totalSpending = spendingData.values.reduce(
    (sum, item) => sum + item,
  );
  double threshold = 0.03;
  double othersValue = 0.0;

  final Map<String, double> mainCategories = {};

  spendingData.forEach((category, value) {
    if (totalSpending <= 0 || value <= 0) return;

    if (value / totalSpending < threshold) {
      othersValue += value;
    } else {
      mainCategories[category] = value;
    }
  });

  if (othersValue > 0) mainCategories['Outros'] = othersValue;

  return mainCategories;
}
