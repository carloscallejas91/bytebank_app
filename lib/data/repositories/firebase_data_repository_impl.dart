import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    TransactionFilter? filter,
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
