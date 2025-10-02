import 'package:mobile_app/app/data/enums/transaction_type.dart';

class TransactionFilter {
  TransactionType? type;
  String? paymentMethod;

  TransactionFilter({this.type, this.paymentMethod});

  bool get isEnabled => type != null || paymentMethod != null;
}