import 'package:mobile_app/data/models/transaction_data_model.dart';
import 'package:mobile_app/data/models/account_data_model.dart';

abstract class ILocalDataSource {
  Future<void> saveTransactions(List<TransactionDataModel> transactions);

  Future<List<TransactionDataModel>> getLastTransactions();

  Future<void> saveMonthlyTransactions(
    String userId,
    DateTime month,
    List<TransactionDataModel> transactions,
  );

  Future<List<TransactionDataModel>> getMonthlyTransactions(
    String userId,
    DateTime month,
  );

  Future<void> saveUserAccount(String userId, AccountDataModel account);

  Future<AccountDataModel?> getLastUserAccount(String userId);

  Future<void> clearCache();
}
