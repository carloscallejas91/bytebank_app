import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/data/enums/transaction_type.dart';
import 'package:mobile_app/app/data/models/transaction_model.dart';

import 'auth_service.dart';

class DatabaseService extends GetxService {
  // Firebase
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Services
  final _authService = Get.find<AuthService>();

  // Streams
  // final StreamController<List<TransactionModel>> _transactionsController =
  //     StreamController.broadcast();
  // StreamSubscription? _transactionsFirestoreSubscription;

  final StreamController<DocumentSnapshot> _userController =
      StreamController.broadcast();
  StreamSubscription? _userFirestoreSubscription;

  late StreamSubscription _authSubscription;

  //================================================================
  // Lifecycle Methods
  //================================================================

  @override
  void onInit() {
    super.onInit();

    _authSubscription = _authService.user.stream.listen(_onUserChanged);
  }

  @override
  void onClose() {
    _userController.close();
    _userFirestoreSubscription?.cancel();
    _authSubscription.cancel();

    super.onClose();
  }

  //================================================================
  // Getters
  //================================================================

  Stream<DocumentSnapshot> getUserStream() => _userController.stream;

  //================================================================
  // Public Functions
  //================================================================

  Future<void> createUserDocument({
    required User user,
    required String name,
  }) async {
    try {
      final userDocRef = _firestore.collection('users').doc(user.uid);
      final userData = {
        'uid': user.uid,
        'name': name,
        'email': user.email,
        'balance': 0.0,
        'account_last4': '1234',
        'account_validity': '12/28',
        'account_type': 'Conta Corrente',
        'createdAt': FieldValue.serverTimestamp(),
      };
      await userDocRef.set(userData);
    } catch (e) {
      debugPrint("createUserDocument: erro ao criar documento do usuário: $e");
      rethrow;
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Nenhum usuário autenticado.');

    final userDocRef = _firestore.collection('users').doc(user.uid);
    final transactionDocRef = _firestore
        .collection('transactions')
        .doc(transaction.id);

    return _firestore.runTransaction((firestoreTransaction) async {
      final double amountChange = transaction.type == TransactionType.income
          ? transaction.amount
          : -transaction.amount;

      firestoreTransaction.set(transactionDocRef, transaction.toMap(user.uid));
      firestoreTransaction.update(userDocRef, {
        'balance': FieldValue.increment(amountChange),
      });
    });
  }

  Future<void> updateTransaction(
    TransactionModel oldTransaction,
    TransactionModel newTransaction,
  ) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Nenhum usuário autenticado.');

    final userDocRef = _firestore.collection('users').doc(user.uid);
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
        newTransaction.toMap(user.uid),
      );
      firestoreTransaction.update(userDocRef, {
        'balance': FieldValue.increment(balanceChange),
      });
    });
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Nenhum usuário autenticado.');

    final userDocRef = _firestore.collection('users').doc(user.uid);
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

  Future<List<TransactionModel>> fetchTransactionsPage({
    required int limit,
    DocumentSnapshot? startAfter,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    Query query = _firestore
        .collection('transactions')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => TransactionModel.fromMap(doc)).toList();
  }

  //================================================================
  // Private Functions
  //================================================================

  void _onUserChanged(User? user) {
    _userFirestoreSubscription?.cancel();

    if (user == null) {
    } else {
      _userFirestoreSubscription = _firestore
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
            _userController.add(snapshot);
          });
    }
  }
}
