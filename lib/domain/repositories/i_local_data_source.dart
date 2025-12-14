import 'package:mobile_app/data/models/transaction_data_model.dart';

abstract class ILocalDataSource {
  Future<void> saveTransactions(List<TransactionDataModel> transactions);
  Future<List<TransactionDataModel>> getLastTransactions();
  Future<void> clearCache();
}