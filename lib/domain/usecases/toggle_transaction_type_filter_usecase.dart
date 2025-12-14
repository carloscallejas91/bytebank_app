import 'package:mobile_app/domain/entities/transaction_filter_model.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';

class ToggleTransactionTypeFilterUseCase {
  TransactionFilterModel call({
    required TransactionFilterModel currentFilter,
    required TransactionType typeToToggle,
  }) {
    if (currentFilter.type == typeToToggle) {
      return TransactionFilterModel(
        type: null,
        paymentMethod: currentFilter.paymentMethod,
        descriptionSearch: currentFilter.descriptionSearch,
        startDate: currentFilter.startDate,
        endDate: currentFilter.endDate,
      );
    } else {
      return TransactionFilterModel(
        type: typeToToggle,
        paymentMethod: currentFilter.paymentMethod,
        descriptionSearch: currentFilter.descriptionSearch,
        startDate: currentFilter.startDate,
        endDate: currentFilter.endDate,
      );
    }
  }
}
