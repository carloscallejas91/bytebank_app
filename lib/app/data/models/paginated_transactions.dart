import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/app/data/models/transaction_model.dart';

class PaginatedTransactions {
  final List<TransactionModel> transactions;
  final DocumentSnapshot? lastDocument;

  PaginatedTransactions({required this.transactions, this.lastDocument});
}