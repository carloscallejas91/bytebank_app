import 'package:mobile_app/app/data/enums/transaction_type.dart';

class TransactionModel {
  final String id;
  final TransactionType type;
  final String description;
  final String paymentMethod;
  final double amount;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.type,
    required this.description,
    required this.paymentMethod,
    required this.amount,
    required this.date,
  });
}
