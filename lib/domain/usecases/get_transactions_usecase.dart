import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/data/models/paginated_transactions.dart';
import 'package:mobile_app/domain/entities/transaction_filter_model.dart';
import 'package:mobile_app/domain/enums/sort_order.dart';
import 'package:mobile_app/domain/repositories/i_transaction_repository.dart';

class GetTransactionsUseCase {
  final ITransactionRepository _repository;

  GetTransactionsUseCase(this._repository);

  Future<PaginatedTransactions> call({
    required String userId,
    required int limit,
    DocumentSnapshot? startAfter,
    TransactionFilterModel? filter,
    SortOrder sortOrder = SortOrder.desc,
  }) {
    return _repository.fetchTransactionsPage(
      userId: userId,
      limit: limit,
      startAfter: startAfter,
      filter: filter,
      sortOrder: sortOrder,
    );
  }
}
