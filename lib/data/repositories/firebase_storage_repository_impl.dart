import 'dart:io';

import 'package:mobile_app/data/datasources/firebase_storage_data_source.dart';
import 'package:mobile_app/domain/repositories/i_storage_repository.dart';

class FirebaseStorageRepositoryImpl implements IStorageRepository {
  final FirebaseStorageDataSource _dataSource;

  FirebaseStorageRepositoryImpl(this._dataSource);

  @override
  Future<String> uploadTransactionReceipt({
    required String userId,
    required String transactionId,
    required File file,
  }) {
    return _dataSource.uploadTransactionReceipt(
      userId: userId,
      transactionId: transactionId,
      file: file,
    );
  }
}
