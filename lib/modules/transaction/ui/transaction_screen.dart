import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';
import 'package:mobile_app/modules/transaction/widgets/transaction_list_item.dart';

class TransactionScreen extends GetView<TransactionController> {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Obx(() {
        if (controller.transactions.isEmpty) {
          return _buildEmptyState();
        } else {
          return _buildContent(theme);
        }
      }),
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text('Nenhuma transação encontrada.'));
  }

  Widget _buildContent(ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildListHeader(theme),
            const SizedBox(height: 16),
            _buildTransactionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildListHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lista de Transações', style: theme.textTheme.titleMedium),
        const Divider(),
      ],
    );
  }

  Widget _buildTransactionList() {
    return Expanded(
      child: ListView.separated(
        itemCount: controller.transactions.length,
        itemBuilder: (context, index) {
          final transaction = controller.transactions[index];
          return TransactionListItem(
            transaction: transaction,
            onTap: () => controller.showOptionsSheet(transaction),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
      ),
    );
  }
}
