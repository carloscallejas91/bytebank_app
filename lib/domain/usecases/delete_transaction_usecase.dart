import 'package:mobile_app/data/models/transaction_data_model.dart';
import 'package:mobile_app/domain/repositories/i_transaction_repository.dart';

class DeleteTransactionUseCase {
  final ITransactionRepository _repository;

  DeleteTransactionUseCase(this._repository);

  Future<void> call({
    required String userId,
    required TransactionDataModel transaction,
  }) {
    return _repository.deleteTransaction(userId, transaction);
  }
}
