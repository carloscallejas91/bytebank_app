import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/app/data/enums/sort_order.dart';
import 'package:mobile_app/app/data/models/paginated_transactions.dart';
import 'package:mobile_app/app/data/models/transaction_filter_model.dart';
import 'package:mobile_app/app/data/models/transaction_model.dart';

abstract class ITransactionRepository {
  Future<PaginatedTransactions> fetchTransactionsPage({
    required String userId,
    required int limit,
    DocumentSnapshot? startAfter,
    TransactionFilter? filter,
    SortOrder sortOrder = SortOrder.desc,
  });

  Future<void> addTransaction(String userId, TransactionModel transaction);

  Future<void> updateTransaction(
    String userId,
    TransactionModel oldTransaction,
    TransactionModel newTransaction,
  );

  Future<void> deleteTransaction(String userId, TransactionModel transaction);
}
