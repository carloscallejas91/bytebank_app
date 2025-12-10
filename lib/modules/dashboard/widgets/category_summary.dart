import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/modules/dashboard/models/category_spending_view_model.dart';

class CategorySummary extends StatelessWidget {
  final String title;
  final List<CategorySpendingViewModel> categories;

  const CategorySummary({
    super.key,
    required this.title,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return Card(
      margin: EdgeInsets.zero,
      color: Get.theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Text(title, style: Get.theme.textTheme.titleMedium),
            const Divider(),
            ...categories.map((viewModel) {
              return _buildSpendingCategory(
                categoryName: viewModel.category,
                value: viewModel.value,
                percentage: viewModel.percentage,
                currencyFormatter: currencyFormatter,
                barColor: viewModel.color,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingCategory({
    required String categoryName,
    required double value,
    required double percentage,
    required NumberFormat currencyFormatter,
    required Color barColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(categoryName, style: Get.theme.textTheme.bodyLarge),
              Text(
                currencyFormatter.format(value),
                style: Get.theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: barColor,
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
              backgroundColor: barColor.withAlpha(50),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(percentage * 100).toStringAsFixed(1)}% do total',
            style: Get.theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
