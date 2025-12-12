import 'package:mobile_app/domain/enums/sort_order.dart';

class ToggleSortOrderUseCase {
  SortOrder call({required SortOrder currentOrder}) {
    return (currentOrder == SortOrder.desc) ? SortOrder.asc : SortOrder.desc;
  }
}
