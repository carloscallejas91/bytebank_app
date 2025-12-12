import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/modules/transaction/models/transaction_list_item_view_model.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionListItemViewModel viewModel;
  final VoidCallback onTap;

  const TransactionListItem({
    super.key,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Get.theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildLeading(),
              const SizedBox(width: 16),
              _buildDetail(),
              _buildValue(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    return CircleAvatar(
      backgroundColor: viewModel.color.withValues(alpha: 0.2),
      child: Icon(viewModel.iconData, color: viewModel.color),
    );
  }

  Widget _buildDetail() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            viewModel.formattedDate,
            style: Get.theme.textTheme.bodySmall?.copyWith(
              color: Get.theme.colorScheme.onSurfaceVariant.withValues(
                alpha: 0.8,
              ),
            ),
          ),
          Text(viewModel.paymentMethod, style: Get.theme.textTheme.titleMedium),
          Text(
            viewModel.description,
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValue() {
    return Text(
      viewModel.formattedAmount,
      style: Get.theme.textTheme.titleMedium?.copyWith(
        color: viewModel.color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
