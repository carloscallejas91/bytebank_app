import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/data/models/transaction_model.dart';

class DatabaseService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

    if (user == null) {
      throw Exception('Nenhum usuário autenticado para adicionar a transação.');
    }

    try {
      final docRef = _firestore.collection('transactions').doc(transaction.id);

      await docRef.set(transaction.toMap(user.uid));
    } catch (e) {
      debugPrint("addTransaction: erro ao adicionar transação: $e");
      rethrow;
    }
  }

  Stream<List<TransactionModel>> getTransactionsStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TransactionModel.fromMap(doc))
              .toList();
        });
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Nenhum usuário autenticado.');
    }

    try {
      final docRef = _firestore.collection('transactions').doc(transaction.id);
      await docRef.update(transaction.toMap(user.uid));
    } catch (e) {
      debugPrint("updateTransaction: erro ao atualizar transação: $e");
      rethrow;
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).delete();
    } catch (e) {
      debugPrint("deleteTransaction: erro ao deletar transação: $e");
      rethrow;
    }
  }
}
