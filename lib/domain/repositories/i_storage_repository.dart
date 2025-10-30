import 'dart:io';

abstract class IStorageRepository {
  Future<String> uploadTransactionReceipt({
    required String userId,
    required String transactionId,
    required File file,
  });
}
