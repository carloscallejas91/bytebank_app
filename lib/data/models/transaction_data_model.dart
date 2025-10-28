import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bytebank_app/domain/entities/transaction_entity.dart';
import 'package:bytebank_app/domain/enums/transaction_type.dart';

class TransactionDataModel extends TransactionEntity {
  final DocumentSnapshot? snapshot;

  TransactionDataModel({
    required String id,
    required TransactionType type,
    required String description,
    required String paymentMethod,
    required double amount,
    required DateTime date,
    String? receiptUrl,
    this.snapshot,
  }) : super(
          id: id,
          type: type,
          description: description,
          paymentMethod: paymentMethod,
          amount: amount,
          date: date,
          receiptUrl: receiptUrl,
        );

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
