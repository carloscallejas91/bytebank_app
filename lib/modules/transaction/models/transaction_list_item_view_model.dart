import 'package:flutter/material.dart';
import 'package:mobile_app/domain/entities/transaction_entity.dart';

class TransactionListItemViewModel {
  final IconData iconData;
  final Color color;
  final String formattedDate;
  final String paymentMethod;
  final String description;
  final String formattedAmount;
  final TransactionEntity originalTransaction;

  TransactionListItemViewModel({
    required this.iconData,
    required this.color,
    required this.formattedDate,
    required this.paymentMethod,
    required this.description,
    required this.formattedAmount,
    required this.originalTransaction,
  });
}
