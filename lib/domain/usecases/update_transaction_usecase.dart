import 'package:bytebank_app/app/data/models/transaction_model.dart';
import 'package:bytebank_app/domain/repositories/i_transaction_repository.dart';

class UpdateTransactionUseCase {
  final ITransactionRepository _repository;

  UpdateTransactionUseCase(this._repository);

  Future<void> call({
    required String userId,
    required TransactionModel oldTransaction,
    required TransactionModel newTransaction,
  }) {
    return _repository.updateTransaction(userId, oldTransaction, newTransaction);
  }
}
