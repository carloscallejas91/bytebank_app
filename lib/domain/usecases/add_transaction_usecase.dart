import 'package:mobile_app/data/models/transaction_data_model.dart';
import 'package:mobile_app/domain/repositories/i_transaction_repository.dart';

class AddTransactionUseCase {
  final ITransactionRepository _repository;

  AddTransactionUseCase(this._repository);

  Future<void> call({
    required String userId,
    required TransactionDataModel transaction,
  }) {
    return _repository.addTransaction(userId, transaction);
  }
}
