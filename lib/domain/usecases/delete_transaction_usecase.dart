import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/domain/repositories/i_transaction_repository.dart';

class DeleteTransactionUseCase {
  final ITransactionRepository _repository;

  DeleteTransactionUseCase(this._repository);

  Future<void> call({
    required String userId,
    required TransactionEntity transaction,
  }) {
    return _repository.deleteTransaction(userId, transaction);
  }
}
