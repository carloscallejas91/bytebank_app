import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/data/models/paginated_transactions.dart';
import 'package:mobile_app/data/models/transaction_data_model.dart';
import 'package:mobile_app/domain/entities/transaction_filter_model.dart';
import 'package:mobile_app/domain/enums/sort_order.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';

class FirebaseDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseDataSource({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance {
    _firestore.settings = const Settings(persistenceEnabled: false);
  }

  // Auth
  Stream<User?> get userChanges {
    return _firebaseAuth.userChanges();
  }

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  Future<User?> signIn(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<User?> createUser(String name, String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
      await user.updateDisplayName(name);
      await createUserDocument(user: user, name: name);
    }
    return user;
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // User
  Stream<DocumentSnapshot> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  Future<void> createUserDocument({required User user, required String name}) {
    final userDocRef = _firestore.collection('users').doc(user.uid);
    return userDocRef.set({
      'uid': user.uid,
      'name': name,
      'email': user.email,
      'balance': 0.0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateUserBalance(String uid, double change) {
    final userDocRef = _firestore.collection('users').doc(uid);
    return userDocRef.update({'balance': FieldValue.increment(change)});
  }

  // Transaction
  Future<void> addTransaction(String userId, TransactionDataModel transaction) {
    final userDocRef = _firestore.collection('users').doc(userId);
    final transactionDocRef = _firestore
        .collection('transactions')
        .doc(transaction.id);

    return _firestore.runTransaction((firestoreTransaction) async {
      final double amountChange = transaction.type == TransactionType.income
          ? transaction.amount
          : -transaction.amount;

      firestoreTransaction.set(transactionDocRef, transaction.toMap(userId));
      firestoreTransaction.update(userDocRef, {
        'balance': FieldValue.increment(amountChange),
      });
    });
  }

  Future<void> updateTransaction(
    String userId,
    TransactionDataModel oldTransaction,
    TransactionDataModel newTransaction,
  ) {
    final userDocRef = _firestore.collection('users').doc(userId);
    final transactionDocRef = _firestore
        .collection('transactions')
        .doc(newTransaction.id);

    return _firestore.runTransaction((firestoreTransaction) async {
      final double oldAmountEffect =
          oldTransaction.type == TransactionType.income
          ? -oldTransaction.amount
          : oldTransaction.amount;
      final double newAmountEffect =
          newTransaction.type == TransactionType.income
          ? newTransaction.amount
          : -newTransaction.amount;
      final double balanceChange = oldAmountEffect + newAmountEffect;

      firestoreTransaction.update(
        transactionDocRef,
        newTransaction.toMap(userId),
      );
      firestoreTransaction.update(userDocRef, {
        'balance': FieldValue.increment(balanceChange),
      });
    });
  }

  Future<void> deleteTransaction(
    String userId,
    TransactionDataModel transaction,
  ) {
    final userDocRef = _firestore.collection('users').doc(userId);
    final transactionDocRef = _firestore
        .collection('transactions')
        .doc(transaction.id);

    return _firestore.runTransaction((firestoreTransaction) async {
      final double amountToRevert = transaction.type == TransactionType.income
          ? -transaction.amount
          : transaction.amount;

      firestoreTransaction.delete(transactionDocRef);
      firestoreTransaction.update(userDocRef, {
        'balance': FieldValue.increment(amountToRevert),
      });
    });
  }

  Future<PaginatedTransactions> fetchTransactionsPage({
    required String userId,
    required int limit,
    DocumentSnapshot? startAfter,
    TransactionFilterModel? filter,
    SortOrder sortOrder = SortOrder.desc,
  }) async {
    Query query = _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId);

    if (filter?.type != null) {
      query = query.where('type', isEqualTo: filter!.type!.name);
    }

    if (filter?.startDate != null) {
      query = query.where(
        'date',
        isGreaterThanOrEqualTo: Timestamp.fromDate(filter!.startDate!),
      );
    }
    if (filter?.endDate != null) {
      query = query.where(
        'date',
        isLessThanOrEqualTo: Timestamp.fromDate(filter!.endDate!),
      );
    }

    final bool isSearching =
        filter?.descriptionSearch != null &&
        filter!.descriptionSearch.isNotEmpty;

    if (isSearching) {
      final searchTerm = filter.descriptionSearch.toLowerCase();
      query = query
          .where('description_lowercase', isGreaterThanOrEqualTo: searchTerm)
          .where('description_lowercase', isLessThan: '$searchTerm\uf8ff');
      query = query.orderBy(
        'description_lowercase',
        descending: sortOrder == SortOrder.desc,
      );
    } else {
      query = query.orderBy('date', descending: sortOrder == SortOrder.desc);
    }

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    query = query.limit(limit);

    final snapshot = await query.get();
    final transactions = snapshot.docs
        .map((doc) => TransactionDataModel.fromMap(doc))
        .toList();
    final lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    return PaginatedTransactions(
      transactions: transactions,
      lastDocument: lastDocument,
    );
  }
}
