import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';
import 'package:mobile_app/modules/transaction/widgets/empty_state.dart';
import 'package:mobile_app/modules/transaction/widgets/filter_chips.dart';
import 'package:mobile_app/modules/transaction/widgets/transaction_list.dart';
import 'package:mobile_app/modules/transaction/widgets/transaction_list_header.dart';
import 'package:mobile_app/modules/transaction/widgets/search_field.dart';

class TransactionScreen extends GetView<TransactionController> {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchField(),
          const SizedBox(height: 16),
          _buildFlip(),
          const SizedBox(height: 24),
          _buildHeader(),
          const SizedBox(height: 8),
          _buildListResult(),
        ],
      ),
    );
  }

  TransactionSearchField _buildSearchField() {
    return TransactionSearchField(
      labelText: 'Pesquisar por descrição',
      searchController: controller.searchController,
      onClearSearch: controller.clearSearch,
      isSearchActive: controller.searchController.text.isNotEmpty,
    );
  }

  Obx _buildFlip() {
    return Obx(
      () => FilterChips(
        incomeLabel: 'Entrada',
        expensesLabel: 'Saída',
        activeFilter: controller.filter.value.type,
        onFilterSelected: controller.toggleTypeFilter,
      ),
    );
  }

  Obx _buildHeader() {
    return Obx(
      () => TransactionListHeader(
        titleText: 'Lista de Transações',
        sortByLabel: 'Data',
        toggleSortTooltip: 'Alterar ordenação',
        sortOrder: controller.sortOrder.value,
        onToggleSortOrder: controller.toggleSortOrder,
      ),
    );
  }

  Expanded _buildListResult() {
    return Expanded(
      child: Obx(() {
        if (controller.showEmptyState) {
          return const EmptyState(textMessage: 'Nenhuma transação encontrada.');
        } else {
          return TransactionList(
            transactions: controller.transactionViewModels,
            scrollController: controller.scrollController,
            isLoadingMore: controller.isLoadingMore.value,
            onTransactionTap: controller.showOptionsSheet,
          );
        }
      }),
    );
  }
}
