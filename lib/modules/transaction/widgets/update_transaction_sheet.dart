import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';

class UpdateTransactionsSheet extends GetView<TransactionController> {
  final String editActionText;
  final String deleteActionText;
  final TransactionEntity transaction;

  const UpdateTransactionsSheet({
    super.key,
    required this.editActionText,
    required this.deleteActionText,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.edit, color: Get.theme.colorScheme.secondary),
            title: Text(editActionText),
            onTap: () {
              Get.back();
              controller.editTransaction(transaction);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: Get.theme.colorScheme.error),
            title: Text(deleteActionText),
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
