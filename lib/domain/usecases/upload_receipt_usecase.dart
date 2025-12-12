import 'dart:io';

import 'package:mobile_app/domain/repositories/i_storage_repository.dart';

class UploadReceiptUseCase {
  final IStorageRepository _repository;

  UploadReceiptUseCase(this._repository);

  Future<String> call({
    required String userId,
    required String transactionId,
    required File file,
  }) {
    return _repository.uploadTransactionReceipt(
      userId: userId,
      transactionId: transactionId,
      file: file,
    );
  }
}
