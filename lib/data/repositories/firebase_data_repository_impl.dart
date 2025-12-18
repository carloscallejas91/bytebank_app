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
import 'package:mobile_app/domain/repositories/i_local_data_source.dart';
import 'package:mobile_app/domain/repositories/i_network_info.dart';
import 'package:mobile_app/domain/repositories/i_transaction_repository.dart';
import 'package:mobile_app/domain/repositories/i_user_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class FirebaseDataRepositoryImpl
    implements IUserRepository, ITransactionRepository {
  final FirebaseDataSource _dataSource;
  final ILocalDataSource _localDataSource;
  final INetworkInfo _networkInfo;

  FirebaseDataRepositoryImpl(
    this._dataSource,
    this._localDataSource,
    this._networkInfo,
  );

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
  }) async {
    final bool canUseCache = startAfter == null;

    if (!canUseCache) {
      return _fetchWithoutCache(
        userId: userId,
        limit: limit,
        startAfter: startAfter,
        filter: filter,
        sortOrder: sortOrder,
      );
    }

    if (await _networkInfo.isConnected) {
      return _fetchFromNetworkAndCache(
        userId: userId,
        limit: limit,
        filter: filter,
        sortOrder: sortOrder,
      );
    } else {
      return _fetchFromCache(filter: filter, sortOrder: sortOrder);
    }
  }

  Future<PaginatedTransactions> _fetchFromNetworkAndCache({
    required String userId,
    required int limit,
    TransactionFilterModel? filter,
    SortOrder sortOrder = SortOrder.desc,
  }) async {
    try {
      final networkResult = await _dataSource.fetchTransactionsPage(
        userId: userId,
        limit: limit,
        startAfter: null,
        filter: filter,
        sortOrder: sortOrder,
      );

      if (!(filter?.isEnabled ?? false)) {
        await _localDataSource.saveTransactions(networkResult.transactions);
      }

      return networkResult;
    } catch (e) {
      debugPrint('Falha ao buscar na rede, usando cache como fallback: $e');
      return _fetchFromCache(filter: filter, sortOrder: sortOrder);
    }
  }

  Future<PaginatedTransactions> _fetchFromCache({
    TransactionFilterModel? filter,
    SortOrder sortOrder = SortOrder.desc,
  }) async {
    final allCachedTransactions = await _localDataSource.getLastTransactions();

    final filteredAndSortedTransactions = _applyClientSideFilters(
      allCachedTransactions,
      filter,
      sortOrder: sortOrder,
    );

    return PaginatedTransactions(
      transactions: filteredAndSortedTransactions,
      lastDocument: null,
    );
  }

  List<TransactionDataModel> _applyClientSideFilters(
    List<TransactionDataModel> transactions,
    TransactionFilterModel? filter, {
    SortOrder sortOrder = SortOrder.desc,
  }) {
    final filteredTransactions = (filter == null || !filter.isEnabled)
        ? transactions
        : transactions.where((transaction) {
            if (filter.type != null && transaction.type != filter.type) {
              return false;
            }
            if (filter.startDate != null &&
                transaction.date.isBefore(filter.startDate!)) {
              return false;
            }
            if (filter.endDate != null &&
                transaction.date.isAfter(filter.endDate!)) {
              return false;
            }
            if (filter.descriptionSearch.isNotEmpty &&
                !transaction.description.toLowerCase().contains(
                  filter.descriptionSearch.toLowerCase(),
                )) {
              return false;
            }
            return true;
          }).toList();

    filteredTransactions.sort((a, b) {
      if (sortOrder == SortOrder.desc) {
        return b.date.compareTo(a.date);
      } else {
        return a.date.compareTo(b.date);
      }
    });

    return filteredTransactions;
  }

  Future<PaginatedTransactions> _fetchWithoutCache({
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
