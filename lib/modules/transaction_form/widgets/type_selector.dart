import 'package:flutter/material.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';

class TypeSelector extends StatelessWidget {
  final String incomeLabel;
  final String expensesLabel;
  final TransactionType selectedType;
  final ValueChanged<TransactionType> onTypeChanged;

  const TypeSelector({
    super.key,
    required this.incomeLabel,
    required this.expensesLabel,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TransactionType>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(
          value: TransactionType.income,
          label: Text(incomeLabel),
          icon: Icon(Icons.arrow_upward),
        ),
        ButtonSegment(
          value: TransactionType.expense,
          label: Text(expensesLabel),
          icon: Icon(Icons.arrow_downward),
        ),
      ],
      selected: {selectedType},
      onSelectionChanged: (newSelection) => onTypeChanged(newSelection.first),
    );
  }
}
