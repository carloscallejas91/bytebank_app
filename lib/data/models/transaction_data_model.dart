import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';

class TransactionDataModel extends TransactionEntity {
  final DocumentSnapshot? snapshot;

  TransactionDataModel({
    required super.id,
    required TransactionType super.type,
    required super.description,
    required super.paymentMethod,
    required super.amount,
    required super.date,
    super.receiptUrl,
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
      'receiptUrl': receiptUrl,
      'date': Timestamp.fromDate(date),
    };
  }

  factory TransactionDataModel.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TransactionDataModel(
      id: doc.id,
      type: (data['type'] as String) == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      description: data['description'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      receiptUrl: data['receiptUrl'],
      date: (data['date'] as Timestamp).toDate(),
      snapshot: doc,
    );
  }
}
