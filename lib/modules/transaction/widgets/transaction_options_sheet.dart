import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/data/models/transaction_model.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';

class TransactionOptionsSheet extends StatelessWidget {
  final TransactionController controller;
  final TransactionModel transaction;

  const TransactionOptionsSheet({
    super.key,
    required this.controller,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text('Editar Transação'),
            onTap: () {
              Get.back();
              controller.editTransaction(transaction);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
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
