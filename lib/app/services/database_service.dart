import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/data/enums/transaction_type.dart';
import 'package:mobile_app/app/data/models/transaction_model.dart';

import 'auth_service.dart';

class DatabaseService extends GetxService {
  final AuthService _authService = Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final StreamController<List<TransactionModel>> _transactionsController = StreamController.broadcast();
  StreamSubscription? _transactionsFirestoreSubscription;

  final StreamController<DocumentSnapshot> _userController = StreamController.broadcast();
  StreamSubscription? _userFirestoreSubscription;

  late StreamSubscription _authSubscription;

  @override
  void onInit() {
    super.onInit();

    _authSubscription = _authService.user.stream.listen(_onUserChanged);
  }

  @override
  void onClose() {
    _transactionsController.close();
    _userController.close();
    _transactionsFirestoreSubscription?.cancel();
    _userFirestoreSubscription?.cancel();
    _authSubscription.cancel();
    super.onClose();
  }

  Stream<DocumentSnapshot> getUserStream() => _userController.stream;
  Stream<List<TransactionModel>> getTransactionsStream() => _transactionsController.stream;

  void _onUserChanged(User? user) {
    _transactionsFirestoreSubscription?.cancel();
    _userFirestoreSubscription?.cancel();

    if (user == null) {
      _transactionsController.add([]);
    } else {
      _userFirestoreSubscription = _firestore
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        _userController.add(snapshot);
      });

      _transactionsFirestoreSubscription = _firestore
          .collection('transactions')
          .where('userId', isEqualTo: user.uid)
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => TransactionModel.fromMap(doc)).toList())
          .listen((transactions) {
        _transactionsController.add(transactions);
      });
    }
  }

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

  // Stream<DocumentSnapshot> getUserStream() {
  //   final user = _auth.currentUser;
  //
  //   if (user == null) return Stream.empty();
  //
  //   return _firestore.collection('users').doc(user.uid).snapshots();
  // }

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

  // Stream<List<TransactionModel>> getTransactionsStream() {
  //   final user = _auth.currentUser;
  //   if (user == null) return Stream.value([]);
  //
  //   return _firestore
  //       .collection('transactions')
  //       .where('userId', isEqualTo: user.uid)
  //       .orderBy('date', descending: true)
  //       .snapshots()
  //       .map((snapshot) {
  //         return snapshot.docs
  //             .map((doc) => TransactionModel.fromMap(doc))
  //             .toList();
  //       });
  // }

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
}
