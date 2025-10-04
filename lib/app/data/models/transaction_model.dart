import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/app/data/enums/transaction_type.dart';

class TransactionModel {
  final String id;
  final TransactionType type;
  final String description;
  final String paymentMethod;
  final double amount;
  final DateTime date;
  final DocumentSnapshot? snapshot;

  TransactionModel({
    required this.id,
    required this.type,
    required this.description,
    required this.paymentMethod,
    required this.amount,
    required this.date,
    this.snapshot,
  });

  Map<String, dynamic> toMap(String userId) {
    return {
      'userId': userId,
      'type': type.name,
      'description': description,
      'description_lowercase': description.toLowerCase(),
      'paymentMethod': paymentMethod,
      'amount': amount,
      'date': Timestamp.fromDate(date),
    };
  }

  factory TransactionModel.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      type: (data['type'] as String) == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      description: data['description'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      snapshot: doc,
    );
  }
}
