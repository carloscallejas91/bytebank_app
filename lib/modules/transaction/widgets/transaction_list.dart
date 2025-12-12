import 'package:flutter/material.dart';
import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/modules/transaction/models/transaction_list_item_view_model.dart';
import 'package:mobile_app/modules/transaction/widgets/transaction_list_item.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionListItemViewModel> transactions;
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
      itemCount: transactions.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < transactions.length) {
          final viewModel = transactions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TransactionListItem(
              viewModel: viewModel,
              onTap: () => onTransactionTap(viewModel.originalTransaction),
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
