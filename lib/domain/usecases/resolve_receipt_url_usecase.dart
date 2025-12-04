import 'dart:io';

import 'package:mobile_app/domain/usecases/upload_receipt_usecase.dart';

class ResolveReceiptUrlUseCase {
  final UploadReceiptUseCase _uploadReceiptUseCase;

  ResolveReceiptUrlUseCase(this._uploadReceiptUseCase);

  Future<String?> call({
    required String userId,
    required String transactionId,
    File? newReceiptFile,
    String? existingReceiptUrl,
  }) async {
    if (newReceiptFile != null) {
      return await _uploadReceiptUseCase.call(
        userId: userId,
        transactionId: transactionId,
        file: newReceiptFile,
      );
    }
    return existingReceiptUrl;
  }
}
