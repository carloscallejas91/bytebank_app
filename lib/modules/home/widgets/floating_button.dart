import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/modules/transaction_form/ui/transaction_form_sheet.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton(
      tooltip: 'Adicionar transação',
      backgroundColor: theme.colorScheme.secondary,
      elevation: 2.0,
      onPressed: () {
        Get.bottomSheet(
          TransactionFormSheet(),
          backgroundColor: theme.colorScheme.surface,
          isScrollControlled: true,
        );
      },
      child: Icon(Icons.add, color: theme.colorScheme.onSecondary),
    );
  }
}
