import 'package:bytebank_app/domain/enums/transaction_type.dart';

class TransactionEntity {
  final String id;
  final TransactionType type;
  final String description;
  final String paymentMethod;
  final double amount;
  final DateTime date;
  final String? receiptUrl;

  TransactionEntity({
    required this.id,
    required this.type,
    required this.description,
    required this.paymentMethod,
    required this.amount,
    required this.date,
    this.receiptUrl,
  });
}
