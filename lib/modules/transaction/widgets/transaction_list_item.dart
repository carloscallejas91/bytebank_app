import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildLeading(),
              const SizedBox(width: 16),
              _buildDetail(theme),
              _buildValue(theme),
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

  Widget _buildDetail(ThemeData theme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            viewModel.formattedDate,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
            ),
          ),
          Text(viewModel.paymentMethod, style: theme.textTheme.titleMedium),
          Text(
            viewModel.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValue(ThemeData theme) {
    return Text(
      viewModel.formattedAmount,
      style: theme.textTheme.titleMedium?.copyWith(
        color: viewModel.color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
