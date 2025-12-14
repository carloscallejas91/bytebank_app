import 'package:mobile_app/domain/enums/transaction_type.dart';

class TransactionFilterModel {
  TransactionType? type;
  String? paymentMethod;
  String descriptionSearch;
  DateTime? startDate;
  DateTime? endDate;

  TransactionFilterModel({
    this.type,
    this.paymentMethod,
    this.descriptionSearch = '',
    this.startDate,
    this.endDate,
  });

  bool get isEnabled {
    return type != null ||
        paymentMethod != null ||
        descriptionSearch.isNotEmpty ||
        startDate != null ||
        endDate != null;
  }
}
