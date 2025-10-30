import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageDataSource {
  final FirebaseStorage _storage;

  FirebaseStorageDataSource({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadTransactionReceipt({
    required String userId,
    required String transactionId,
    required File file,
  }) async {
    try {
      final ref = _storage.ref('receipts/$userId/$transactionId.jpg');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      debugPrint("uploadTransactionReceipt: erro no upload do recibo: $e");
      rethrow;
    }
  }
}
