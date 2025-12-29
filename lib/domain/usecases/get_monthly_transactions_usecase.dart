import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/domain/repositories/i_transaction_repository.dart';

class GetMonthlyTransactionsUseCase {
  final ITransactionRepository _repository;

  GetMonthlyTransactionsUseCase(this._repository);

  Future<List<TransactionEntity>> call({
    required String userId,
    required DateTime selectedMonth,
  }) {
    return _repository.getTransactionsForMonth(userId, selectedMonth);
  }
}
