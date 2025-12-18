import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';

class TransactionDataModel extends TransactionEntity {
  final DocumentSnapshot? snapshot;

  TransactionDataModel({
    required super.id,
    required super.type,
    required super.description,
    required super.paymentMethod,
    required super.amount,
    required super.date,
    super.receiptUrl,
    this.snapshot,
  });

  factory TransactionDataModel.fromEntity(TransactionEntity entity) {
    return TransactionDataModel(
      id: entity.id,
      type: entity.type,
      description: entity.description,
      paymentMethod: entity.paymentMethod,
      amount: entity.amount,
      date: entity.date,
      receiptUrl: entity.receiptUrl,
    );
  }

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

  // --- NOVOS MÉTODOS PARA CACHE ---
  // Converte o objeto para um Map (JSON) para ser salvo no cache local.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'description': description,
      'paymentMethod': paymentMethod,
      'amount': amount,
      'receiptUrl': receiptUrl,
      'date': date.toIso8601String(),
    };
  }

  // Constrói um objeto a partir de um Map (JSON) lido do cache local.
  factory TransactionDataModel.fromJson(Map<String, dynamic> json) {
    return TransactionDataModel(
      id: json['id'] as String,
      type: (json['type'] as String) == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      description: json['description'] as String,
      paymentMethod: json['paymentMethod'] as String,
      amount: (json['amount'] as num).toDouble(),
      receiptUrl: json['receiptUrl'] as String?,
      date: DateTime.parse(json['date'] as String),
      snapshot: null,
    );
  }
}
