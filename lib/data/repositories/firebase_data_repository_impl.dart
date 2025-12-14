import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_app/data/datasources/firebase_data_source.dart';
import 'package:mobile_app/data/models/account_data_model.dart';
import 'package:mobile_app/data/models/paginated_transactions.dart';
import 'package:mobile_app/data/models/transaction_data_model.dart';
import 'package:mobile_app/domain/entities/account_entity.dart';
import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/domain/entities/transaction_filter_model.dart';
import 'package:mobile_app/domain/enums/sort_order.dart';
import 'package:mobile_app/domain/repositories/i_transaction_repository.dart';
import 'package:mobile_app/domain/repositories/i_user_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class FirebaseDataRepositoryImpl
    implements IUserRepository, ITransactionRepository {
  final FirebaseDataSource _dataSource;

  FirebaseDataRepositoryImpl(this._dataSource);

  // User Repository
  @override
  Stream<AccountEntity> getUserStream(String uid) {
    return _dataSource.getUserStream(uid).map((doc) {
      return AccountDataModel.fromDocument(doc);
    });
  }

  @override
  Future<void> createUserDocument({required User user, required String name}) {
    return _dataSource.createUserDocument(user: user, name: name);
  }

  @override
  Future<void> updateUserBalance(String uid, double change) {
    return _dataSource.updateUserBalance(uid, change);
  }

  @override
  Future<String> saveAvatar({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(imageFile.path);
      final savedImage = await imageFile.copy('${appDir.path}/$fileName');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_avatar_path_$userId', savedImage.path);

      return savedImage.path;
    } catch (e) {
      debugPrint('Falha ao salvar avatar localmente: $e');
      rethrow;
    }
  }

  @override
  Future<String?> getCachedAvatarPath({required String userId}) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('user_avatar_path_$userId');
  }

  // Transaction Repository
  @override
  Future<void> addTransaction(String userId, TransactionEntity transaction) {
    final transactionModel = TransactionDataModel.fromEntity(transaction);
    return _dataSource.addTransaction(userId, transactionModel);
  }

  @override
  Future<void> deleteTransaction(String userId, TransactionEntity transaction) {
    final transactionModel = TransactionDataModel.fromEntity(transaction);
    return _dataSource.deleteTransaction(userId, transactionModel);
  }

  @override
  Future<PaginatedTransactions> fetchTransactionsPage({
    required String userId,
    required int limit,
    DocumentSnapshot? startAfter,
    TransactionFilterModel? filter,
    SortOrder sortOrder = SortOrder.desc,
  }) {
    return _dataSource.fetchTransactionsPage(
      userId: userId,
      limit: limit,
      startAfter: startAfter,
      filter: filter,
      sortOrder: sortOrder,
    );
  }

  @override
  Future<void> updateTransaction(
    String userId,
    TransactionEntity oldTransaction,
    TransactionEntity newTransaction,
  ) {
    final oldTransactionModel = TransactionDataModel.fromEntity(oldTransaction);
    final newTransactionModel = TransactionDataModel.fromEntity(newTransaction);
    return _dataSource.updateTransaction(
      userId,
      oldTransactionModel,
      newTransactionModel,
    );
  }
}
