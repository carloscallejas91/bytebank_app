import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/domain/repositories/i_transaction_repository.dart';

class AddTransactionUseCase {
  final ITransactionRepository _repository;

  AddTransactionUseCase(this._repository);

  Future<void> call({
    required String userId,
    required TransactionEntity transaction,
  }) {
    return _repository.addTransaction(userId, transaction);
  }
}
