import 'package:get_storage/get_storage.dart';
import 'package:mobile_app/data/models/transaction_data_model.dart';
import 'package:mobile_app/domain/repositories/i_local_data_source.dart';

class LocalDataSource implements ILocalDataSource {
  final _box = GetStorage();
  final String _transactionsCacheKey = 'last_transactions';

  @override
  Future<List<TransactionDataModel>> getLastTransactions() async {
    final cachedData = _box.read<List<dynamic>>(_transactionsCacheKey);

    if (cachedData != null) {
      try {
        return cachedData
            .map(
              (json) =>
                  TransactionDataModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } catch (e) {
        await clearCache();
        return [];
      }
    }
    return [];
  }

  @override
  Future<void> saveTransactions(List<TransactionDataModel> transactions) async {
    final List<Map<String, dynamic>> jsonList = transactions
        .map((t) => t.toJson())
        .toList();

    await _box.write(_transactionsCacheKey, jsonList);
  }

  @override
  Future<void> clearCache() async {
    await _box.remove(_transactionsCacheKey);
  }
}
