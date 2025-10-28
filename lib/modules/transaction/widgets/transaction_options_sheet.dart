import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/data/models/transaction_data_model.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';

class TransactionOptionsSheet extends GetView<TransactionController> {
  final TransactionDataModel transaction;

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
            leading: Icon(Icons.edit, color: theme.colorScheme.secondary),
            title: Text('Editar transação'),
            onTap: () {
              Get.back();
              controller.editTransaction(transaction);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: theme.colorScheme.error),
            title: Text('Deletar transação'),
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
