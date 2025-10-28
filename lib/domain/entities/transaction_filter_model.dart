import 'package:bytebank_app/domain/enums/transaction_type.dart';

class TransactionFilter {
  TransactionType? type;
  String? paymentMethod;
  String descriptionSearch;

  TransactionFilter({this.type, this.paymentMethod, this.descriptionSearch = ''});

  bool get isEnabled {
    return type != null || paymentMethod != null || descriptionSearch.isNotEmpty;
  }
}
