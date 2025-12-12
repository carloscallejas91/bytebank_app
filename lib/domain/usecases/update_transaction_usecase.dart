import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/domain/repositories/i_transaction_repository.dart';

class UpdateTransactionUseCase {
  final ITransactionRepository _repository;

  UpdateTransactionUseCase(this._repository);

  Future<void> call({
    required String userId,
    required TransactionEntity oldTransaction,
    required TransactionEntity newTransaction,
  }) {
    return _repository.updateTransaction(
      userId,
      oldTransaction,
      newTransaction,
    );
  }
}
