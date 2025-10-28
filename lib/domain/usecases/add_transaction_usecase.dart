import 'package:bytebank_app/app/data/models/transaction_model.dart';
import 'package:bytebank_app/domain/repositories/i_transaction_repository.dart';

class AddTransactionUseCase {
  final ITransactionRepository _repository;

  AddTransactionUseCase(this._repository);

  Future<void> call({
    required String userId,
    required TransactionModel transaction,
  }) {
    return _repository.addTransaction(userId, transaction);
  }
}
