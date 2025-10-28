import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/domain/enums/sort_order.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';
import 'package:mobile_app/modules/transaction/widgets/transaction_list_item.dart';

class TransactionScreen extends GetView<TransactionController> {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: _buildContent(theme),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: const Center(child: Text('Nenhuma transação encontrada.')),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            _buildListHeader(theme),
            _buildSearchField(theme),
            _buildFilters(),
            Obx(() {
              if (controller.transactions.isEmpty) {
                return _buildEmptyState();
              } else {
                return _buildTransactionList();
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildListHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Lista de Transações', style: theme.textTheme.titleMedium),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 14),
                SizedBox(width: 4),
                Text(
                  'Data',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => IconButton(
                    icon: Icon(
                      controller.sortOrder.value == SortOrder.desc
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                    ),
                    tooltip: 'Alterar ordenação',
                    onPressed: controller.toggleSortOrder,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return TextField(
      controller: controller.searchController,
      decoration: InputDecoration(
        labelText: 'Pesquisar por descrição',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Obx(
          () => controller.filter.value.descriptionSearch.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: controller.clearSearch,
                )
              : const SizedBox.shrink(),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(width: 1.0),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Obx(
      () => Wrap(
        spacing: 8.0,
        children: [
          FilterChip(
            label: const Text('Saídas'),
            selected: controller.filter.value.type == TransactionType.expense,
            onSelected: (selected) {
              controller.toggleTypeFilter(TransactionType.expense);
            },
          ),
          FilterChip(
            label: const Text('Entradas'),
            selected: controller.filter.value.type == TransactionType.income,
            onSelected: (selected) {
              controller.toggleTypeFilter(TransactionType.income);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: controller.refreshTransactions,
        child: Obx(
          () => ListView.separated(
            controller: controller.scrollController,
            itemCount:
                controller.transactions.length +
                (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.transactions.length) {
                return controller.isLoadingMore.value
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink();
              }
              final transaction = controller.transactions[index];
              return TransactionListItem(
                transaction: transaction,
                onTap: () => controller.showOptionsSheet(transaction),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
          ),
        ),
      ),
    );
  }
}
