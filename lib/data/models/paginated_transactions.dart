import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bytebank_app/data/models/transaction_data_model.dart';

class PaginatedTransactions {
  final List<TransactionDataModel> transactions;
  final DocumentSnapshot? lastDocument;

  PaginatedTransactions({required this.transactions, this.lastDocument});
}
