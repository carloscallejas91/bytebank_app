import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

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