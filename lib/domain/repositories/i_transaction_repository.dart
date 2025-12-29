import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/data/models/paginated_transactions.dart';
import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/domain/entities/transaction_filter_model.dart';
import 'package:mobile_app/domain/enums/sort_order.dart';

abstract class ITransactionRepository {
  Future<PaginatedTransactions> fetchTransactionsPage({
    required String userId,
    required int limit,
    DocumentSnapshot? startAfter,
    TransactionFilterModel? filter,
    SortOrder sortOrder = SortOrder.desc,
  });

  Future<void> addTransaction(String userId, TransactionEntity transaction);

  Future<void> updateTransaction(
    String userId,
    TransactionEntity oldTransaction,
    TransactionEntity newTransaction,
  );

  Future<void> deleteTransaction(String userId, TransactionEntity transaction);

  Future<List<TransactionEntity>> getTransactionsForMonth(
    String userId,
    DateTime month,
  );
}
