import 'package:flutter/material.dart';
import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/modules/transaction/widgets/transaction_list_item.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final Function(TransactionEntity) onTransactionTap;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.scrollController,
    required this.isLoadingMore,
    required this.onTransactionTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: transactions.length + 1,
      itemBuilder: (context, index) {
        if (index < transactions.length) {
          final transaction = transactions[index];
          return TransactionListItem(
            transaction: transaction,
            onTap: () => onTransactionTap(transaction),
          );
        } else {
          return isLoadingMore
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink();
        }
      },
    );
  }
}
