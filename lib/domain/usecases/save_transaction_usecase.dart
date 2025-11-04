import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/domain/usecases/add_transaction_usecase.dart';
import 'package:mobile_app/domain/usecases/update_transaction_usecase.dart';

class SaveTransactionUseCase {
  final AddTransactionUseCase _addTransactionUseCase;
  final UpdateTransactionUseCase _updateTransactionUseCase;

  SaveTransactionUseCase(
    this._addTransactionUseCase,
    this._updateTransactionUseCase,
  );

  Future<void> call({
    required String userId,
    required TransactionEntity transaction,
    TransactionEntity? oldTransaction,
  }) {
    if (oldTransaction != null) {
      return _updateTransactionUseCase.call(
        userId: userId,
        oldTransaction: oldTransaction,
        newTransaction: transaction,
      );
    } else {
      return _addTransactionUseCase.call(
        userId: userId,
        transaction: transaction,
      );
    }
  }
}
