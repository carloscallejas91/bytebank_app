import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/data/models/transaction_model.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';

class TransactionOptionsSheet extends GetView<TransactionController> {
  final TransactionModel transaction;

  const TransactionOptionsSheet({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.edit, color: theme.colorScheme.onSurface),
            title: Text('Editar Transação'),
            onTap: () {
              Get.back();
              controller.editTransaction(transaction);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: theme.colorScheme.error),
            title: Text('Deletar Transação'),
            onTap: () {
              Get.back();
              controller.deleteTransaction(transaction);
            },
          ),
        ],
      ),
    );
  }
}
