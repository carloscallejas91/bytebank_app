import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';
import 'package:mobile_app/modules/transaction/widgets/transaction_list_item.dart';
import 'package:mobile_app/modules/transaction/widgets/transaction_options_sheet.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionController>();
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Obx(() {
        if (controller.transactions.isEmpty) {
          return const Center(child: Text('Nenhuma transação encontrada.'));
        }
        return Card(
          margin: EdgeInsets.zero,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                Text('Lista de Transações', style: theme.textTheme.titleMedium),
                const Divider(),
                Expanded(
                  child: ListView.separated(
                    itemCount: controller.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = controller.transactions[index];
                      return TransactionListItem(
                        transaction: transaction,
                        onTap: () {
                          Get.bottomSheet(
                            TransactionOptionsSheet(
                              controller: controller,
                              transactionId: transaction.id,
                            ),
                            backgroundColor: theme.colorScheme.surface,
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
