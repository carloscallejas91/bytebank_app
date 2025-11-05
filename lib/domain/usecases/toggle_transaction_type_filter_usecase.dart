import 'package:mobile_app/domain/entities/transaction_filter_model.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';

class ToggleTransactionTypeFilterUseCase {
  TransactionFilter call({
    required TransactionFilter currentFilter,
    required TransactionType typeToToggle,
  }) {
    if (currentFilter.type == typeToToggle) {
      return TransactionFilter(
        type: null,
        paymentMethod: currentFilter.paymentMethod,
        descriptionSearch: currentFilter.descriptionSearch,
      );
    } else {
      return TransactionFilter(
        type: typeToToggle,
        paymentMethod: currentFilter.paymentMethod,
        descriptionSearch: currentFilter.descriptionSearch,
      );
    }
  }
}
