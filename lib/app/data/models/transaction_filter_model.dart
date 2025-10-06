import 'package:mobile_app/app/data/enums/transaction_type.dart';

class TransactionFilter {
  TransactionType? type;
  String? paymentMethod;
  String descriptionSearch;

  TransactionFilter({this.type, this.paymentMethod, this.descriptionSearch = ''});

  bool get isEnabled => type != null || paymentMethod != null || descriptionSearch.isNotEmpty;
}