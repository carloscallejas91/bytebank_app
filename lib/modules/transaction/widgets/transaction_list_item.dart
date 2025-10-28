import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app/utils/date_formatter.dart';
import 'package:mobile_app/data/models/transaction_data_model.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionDataModel transaction;
  final VoidCallback onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final currencyFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    final isIncome = transaction.type == TransactionType.income;
    final iconData = isIncome ? Icons.arrow_upward : Icons.arrow_downward;
    final color = isIncome ? Colors.green : theme.colorScheme.error;

    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            spacing: 16,
            children: [
              _buildLeading(color, iconData),
              _buildDetail(theme),
              _buildValue(currencyFormatter, theme, color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(Color color, IconData iconData) {
    return CircleAvatar(
      backgroundColor: color.withValues(alpha: .2),
      child: Icon(iconData, color: color),
    );
  }

  Widget _buildDetail(ThemeData theme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormatter.formatFriendlyDate(transaction.date),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
            ),
          ),
          Text(transaction.paymentMethod, style: theme.textTheme.titleMedium),
          Text(
            transaction.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValue(
    NumberFormat currencyFormatter,
    ThemeData theme,
    Color color,
  ) {
    return Text(
      currencyFormatter.format(transaction.amount),
      style: theme.textTheme.titleMedium?.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
