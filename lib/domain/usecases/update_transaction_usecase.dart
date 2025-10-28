import 'package:mobile_app/data/models/transaction_data_model.dart';
import 'package:mobile_app/domain/repositories/i_transaction_repository.dart';

class UpdateTransactionUseCase {
  final ITransactionRepository _repository;

  UpdateTransactionUseCase(this._repository);

  Future<void> call({
    required String userId,
    required TransactionDataModel oldTransaction,
    required TransactionDataModel newTransaction,
  }) {
    return _repository.updateTransaction(
      userId,
      oldTransaction,
      newTransaction,
    );
  }
}
