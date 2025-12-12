import 'package:flutter/material.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';

class FilterChips extends StatelessWidget {
  final String incomeLabel;
  final String expensesLabel;
  final TransactionType? activeFilter;
  final Function(TransactionType) onFilterSelected;

  const FilterChips({
    super.key,
    required this.incomeLabel,
    required this.expensesLabel,
    this.activeFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        FilterChip(
          label: Text(incomeLabel),
          selected: activeFilter == TransactionType.income,
          onSelected: (_) => onFilterSelected(TransactionType.income),
        ),
        FilterChip(
          label: Text(expensesLabel),
          selected: activeFilter == TransactionType.expense,
          onSelected: (_) => onFilterSelected(TransactionType.expense),
        ),
      ],
    );
  }
}
