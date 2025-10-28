import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bytebank_app/data/datasources/firebase_data_source.dart';
import 'package:bytebank_app/data/models/paginated_transactions.dart';
import 'package:bytebank_app/data/models/transaction_data_model.dart';
import 'package:bytebank_app/domain/entities/transaction_entity.dart';
import 'package:bytebank_app/domain/entities/transaction_filter_model.dart';
import 'package:bytebank_app/domain/enums/sort_order.dart';
import 'package:bytebank_app/domain/repositories/i_transaction_repository.dart';
import 'package:bytebank_app/domain/repositories/i_user_repository.dart';

class FirebaseDataRepositoryImpl implements IUserRepository, ITransactionRepository {
  final FirebaseDataSource _dataSource;

  FirebaseDataRepositoryImpl(this._dataSource);

  // User Repository
  @override
  Stream<DocumentSnapshot> getUserStream(String uid) {
    return _dataSource.getUserStream(uid);
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
    final transactionModel = TransactionDataModel(
      id: transaction.id,
      type: transaction.type,
      description: transaction.description,
      paymentMethod: transaction.paymentMethod,
      amount: transaction.amount,
      date: transaction.date,
      receiptUrl: transaction.receiptUrl,
    );
    return _dataSource.addTransaction(userId, transactionModel);
  }

  @override
  Future<void> deleteTransaction(String userId, TransactionEntity transaction) {
    final transactionModel = TransactionDataModel(
      id: transaction.id,
      type: transaction.type,
      description: transaction.description,
      paymentMethod: transaction.paymentMethod,
      amount: transaction.amount,
      date: transaction.date,
      receiptUrl: transaction.receiptUrl,
    );
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
    // A camada de dados retorna o modelo de dados, que é uma implementação da entidade.
    // O Use Case receberá a lista de `TransactionDataModel` e a tratará como `TransactionEntity`.
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
    final oldTransactionModel = TransactionDataModel(
      id: oldTransaction.id,
      type: oldTransaction.type,
      description: oldTransaction.description,
      paymentMethod: oldTransaction.paymentMethod,
      amount: oldTransaction.amount,
      date: oldTransaction.date,
      receiptUrl: oldTransaction.receiptUrl,
    );
    final newTransactionModel = TransactionDataModel(
      id: newTransaction.id,
      type: newTransaction.type,
      description: newTransaction.description,
      paymentMethod: newTransaction.paymentMethod,
      amount: newTransaction.amount,
      date: newTransaction.date,
      receiptUrl: newTransaction.receiptUrl,
    );
    return _dataSource.updateTransaction(userId, oldTransactionModel, newTransactionModel);
  }
}
