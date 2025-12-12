import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/app/ui/widgets/app_dialogs.dart';
import 'package:mobile_app/app/utils/date_formatter.dart';
import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/domain/entities/transaction_filter_model.dart';
import 'package:mobile_app/domain/enums/sort_order.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';
import 'package:mobile_app/domain/usecases/delete_transaction_usecase.dart';
import 'package:mobile_app/domain/usecases/get_transactions_usecase.dart';
import 'package:mobile_app/domain/usecases/toggle_sort_order_usecase.dart';
import 'package:mobile_app/domain/usecases/toggle_transaction_type_filter_usecase.dart';
import 'package:mobile_app/modules/transaction/models/transaction_list_item_view_model.dart';
import 'package:mobile_app/modules/transaction/widgets/update_transaction_sheet.dart';
import 'package:mobile_app/modules/transaction_form/ui/transaction_form_sheet.dart';

class TransactionController extends GetxController {
  // Services
  final _snackBarService = Get.find<SnackBarService>();

  // Repositories
  final _authRepository = Get.find<IAuthRepository>();

  // Use Cases
  final _getTransactionsUseCase = Get.find<GetTransactionsUseCase>();
  final _deleteTransactionUseCase = Get.find<DeleteTransactionUseCase>();
  final _toggleTransactionTypeFilterUseCase =
      Get.find<ToggleTransactionTypeFilterUseCase>();
  final _toggleSortOrderUseCase = Get.find<ToggleSortOrderUseCase>();

  // UI Controllers
  final scrollController = ScrollController();
  final searchController = TextEditingController();

  // Transaction State
  final transactionViewModels = <TransactionListItemViewModel>[].obs;
  final transactions = <TransactionEntity>[].obs;
  final filter = TransactionFilter().obs;
  final sortOrder = SortOrder.desc.obs;

  // Formatters
  final _currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  // Pagination State
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  DocumentSnapshot? _lastDocument;

  // Internals
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);

    ever(transactions, _mapEntitiesToViewModels);

    fetchFirstPage();
    _setupSearchListener();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  // Getters
  bool get showEmptyState =>
      transactionViewModels.isEmpty && !isLoadingMore.value;

  // UI Actions
  Future<void> refreshTransactions() async {
    _lastDocument = null;
    hasMore.value = true;
    transactions.clear();
    await _fetchPage();
  }

  Future<void> fetchFirstPage() async {
    await _fetchPage();
  }

  Future<void> fetchNextPage() async {
    if (isLoadingMore.value || !hasMore.value) return;
    await _fetchPage(startAfter: _lastDocument);
  }

  void deleteTransaction(TransactionEntity transaction) {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) return;

    AppDialogs.showConfirmationDialog(
      title: 'Confirmar exclusão',
      message:
          'Você tem certeza que deseja excluir esta transação? Esta ação não poderá ser desfeita.',
      onConfirm: () async {
        try {
          await _deleteTransactionUseCase.call(
            userId: userId,
            transaction: transaction,
          );

          await refreshTransactions();

          _snackBarService.showSuccess(
            title: 'Sucesso!',
            message: 'Transação deletada.',
          );
        } catch (e) {
          _snackBarService.showError(
            title: 'Erro',
            message: 'Não foi possível deletar a transação.',
          );
        }
      },
    );
  }

  void toggleTypeFilter(TransactionType type) {
    filter.value = _toggleTransactionTypeFilterUseCase.call(
      currentFilter: filter.value,
      typeToToggle: type,
    );
    filter.refresh();
    refreshTransactions();
  }

  void toggleSortOrder() {
    sortOrder.value = _toggleSortOrderUseCase.call(
      currentOrder: sortOrder.value,
    );

    refreshTransactions();
  }

  void showOptionsSheet(TransactionEntity transaction) {
    _showAppBottomSheet(
      UpdateTransactionsSheet(
        editActionText: 'Editar transação',
        deleteActionText: 'Deletar transação',
        transaction: transaction,
      ),
    );
  }

  void editTransaction(TransactionEntity transactionToEdit) {
    _showAppBottomSheet(
      const TransactionFormSheet(),
      isScrollControlled: true,
      settings: RouteSettings(
        arguments: {
          'transaction': transactionToEdit,
          'onSaveSuccess': () {
            refreshTransactions();
          },
        },
      ),
    );
  }

  void clearSearch() {
    searchController.clear();
  }

  // Internal Logic & Private Methods
  void _showAppBottomSheet(
    Widget sheetContent, {
    bool isScrollControlled = false,
    RouteSettings? settings,
  }) {
    Get.bottomSheet(
      sheetContent,
      backgroundColor: Get.theme.colorScheme.surface,
      isScrollControlled: isScrollControlled,
      settings: settings,
    );
  }

  Future<void> _fetchPage({DocumentSnapshot? startAfter}) async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) return;

    isLoadingMore.value = true;
    try {
      final pageResult = await _getTransactionsUseCase.call(
        userId: userId,
        limit: 10,
        startAfter: startAfter,
        filter: filter.value,
        sortOrder: sortOrder.value,
      );

      final isFirstPage = startAfter == null;
      _lastDocument = pageResult.lastDocument;

      if (isFirstPage) {
        transactions.assignAll(pageResult.transactions);
      } else {
        transactions.addAll(pageResult.transactions);
      }

      if (pageResult.transactions.length < 10) {
        hasMore.value = false;
      }
    } catch (e) {
      _snackBarService.showError(
        title: 'Erro',
        message: 'Não foi possível buscar as transações.',
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  void _mapEntitiesToViewModels(List<TransactionEntity> entities) {
    final viewModels = entities.map((entity) {
      final isIncome = entity.type == TransactionType.income;
      return TransactionListItemViewModel(
        iconData: isIncome ? Icons.arrow_upward : Icons.arrow_downward,
        color: isIncome ? Colors.green : Get.theme.colorScheme.error,
        formattedDate: DateFormatter.formatFriendlyDate(entity.date),
        paymentMethod: entity.paymentMethod,
        description: entity.description,
        formattedAmount: _currencyFormatter.format(entity.amount),
        originalTransaction: entity,
      );
    }).toList();

    transactionViewModels.assignAll(viewModels);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchNextPage();
    }
  }

  void _setupSearchListener() {
    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        final searchTerm = searchController.text.toLowerCase();
        if (filter.value.descriptionSearch != searchTerm) {
          filter.value.descriptionSearch = searchTerm;
          refreshTransactions();
        }
      });
    });
  }
}
