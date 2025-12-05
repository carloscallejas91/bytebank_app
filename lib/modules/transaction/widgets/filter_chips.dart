import 'package:flutter/material.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';

class FilterChips extends StatelessWidget {
  final TransactionType? activeFilter;
  final Function(TransactionType) onFilterSelected;

  const FilterChips({
    super.key,
    this.activeFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        FilterChip(
          label: const Text('Entrada'),
          selected: activeFilter == TransactionType.income,
          onSelected: (_) => onFilterSelected(TransactionType.income),
        ),
        FilterChip(
          label: const Text('Saída'),
          selected: activeFilter == TransactionType.expense,
          onSelected: (_) => onFilterSelected(TransactionType.expense),
        ),
      ],
    );
  }
}
