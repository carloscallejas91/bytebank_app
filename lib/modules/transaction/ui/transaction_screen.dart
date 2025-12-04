import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';
import 'package:mobile_app/modules/transaction/widgets/transaction_empty_state.dart';
import 'package:mobile_app/modules/transaction/widgets/transaction_filter_chips.dart';
import 'package:mobile_app/modules/transaction/widgets/transaction_list.dart';
import 'package:mobile_app/modules/transaction/widgets/transaction_list_header.dart';
import 'package:mobile_app/modules/transaction/widgets/transaction_search_field.dart';

class TransactionScreen extends GetView<TransactionController> {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TransactionSearchField(
            searchController: controller.searchController,
            onClearSearch: controller.clearSearch,
            isSearchActive: controller.searchController.text.isNotEmpty,
          ),
          const SizedBox(height: 16),
          Obx(
            () => TransactionFilterChips(
              activeFilter: controller.filter.value.type,
              onFilterSelected: controller.toggleTypeFilter,
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () => TransactionListHeader(
              sortOrder: controller.sortOrder.value,
              onToggleSortOrder: controller.toggleSortOrder,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.transactions.isEmpty &&
                  !controller.isLoadingMore.value) {
                return const TransactionEmptyState();
              } else {
                return TransactionList(
                  transactions: controller.transactions,
                  scrollController: controller.scrollController,
                  isLoadingMore: controller.isLoadingMore.value,
                  onTransactionTap: controller.showOptionsSheet,
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
