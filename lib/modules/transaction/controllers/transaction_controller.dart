import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/data/enums/sort_order.dart';
import 'package:mobile_app/app/data/enums/transaction_type.dart';
import 'package:mobile_app/app/data/models/transaction_filter_model.dart';
import 'package:mobile_app/app/data/models/transaction_model.dart';
import 'package:mobile_app/app/services/database_service.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/app/ui/widgets/app_dialogs.dart';
import 'package:mobile_app/modules/home/widgets/transaction_form_sheet.dart';
import 'package:mobile_app/modules/transaction/widgets/transaction_options_sheet.dart';

class TransactionController extends GetxController {
  // Services
  final _databaseService = Get.find<DatabaseService>();
  final _snackBarService = Get.find<SnackBarService>();

  // Controller
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  // List
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;

  // Pagination
  final int _limit = 6;
  DocumentSnapshot? _lastDocument;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;

  // Filter
  final Rx<TransactionFilter> filter = TransactionFilter().obs;
  final Rx<SortOrder> sortOrder = SortOrder.desc.obs;
  Timer? _debounce;

  //================================================================
  // Lifecycle Methods
  //================================================================

  @override
  void onInit() {
    super.onInit();

    fetchFirstPage();

    scrollController.addListener(_scrollListener);

    _setupSearchListener();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();

    super.onClose();
  }

  //================================================================
  // Public Functions
  //================================================================

  Future<void> refreshTransactions() async {
    _lastDocument = null;
    hasMore.value = true;

    transactions.clear();

    await fetchFirstPage();
  }

  Future<void> fetchFirstPage() async {
    isLoadingMore.value = true;
    try {
      final pageResult = await _databaseService.fetchTransactionsPage(
        limit: _limit,
        filter: filter.value,
        sortOrder: sortOrder.value,
      );
      if (pageResult.transactions.isNotEmpty) {
        _lastDocument = pageResult.lastDocument;
      }

      transactions.assignAll(pageResult.transactions);

      hasMore.value = pageResult.transactions.length == _limit;
    } catch (e) {
      _snackBarService.showError(
        title: 'Erro',
        message: 'Não foi possível buscar as transações.',
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> fetchNextPage() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    try {
      final pageResult = await _databaseService.fetchTransactionsPage(
        limit: _limit,
        startAfter: _lastDocument,
        filter: filter.value,
        sortOrder: sortOrder.value,
      );
      if (pageResult.transactions.isNotEmpty) {
        _lastDocument = pageResult.lastDocument;
        transactions.addAll(pageResult.transactions);
      } else {
        hasMore.value = false;
      }

      if (pageResult.transactions.length < _limit) {
        hasMore.value = false;
      }
    } catch (e) {
      _snackBarService.showError(
        title: 'Erro',
        message: 'Não foi possível buscar mais transações.',
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  void toggleTypeFilter(TransactionType type) {
    if (filter.value.type == type) {
      filter.value.type = null;
    } else {
      filter.value.type = type;
    }

    filter.refresh();

    refreshTransactions();
  }

  void toggleSortOrder() {
    sortOrder.value = (sortOrder.value == SortOrder.desc) ? SortOrder.asc : SortOrder.desc;

    refreshTransactions();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchNextPage();
    }
  }

  void showOptionsSheet(TransactionModel transaction) {
    final theme = Theme.of(Get.context!);

    Get.bottomSheet(
      TransactionOptionsSheet(transaction: transaction),

      backgroundColor: theme.colorScheme.surface,
    );
  }

  void editTransaction(TransactionModel transactionToEdit) {
    Get.bottomSheet(
      const TransactionFormSheet(),
      backgroundColor: Get.theme.colorScheme.surface,
      isScrollControlled: true,
      settings: RouteSettings(arguments: transactionToEdit),
    );
  }

  void deleteTransaction(TransactionModel transaction) {
    AppDialogs.showConfirmationDialog(
      title: 'Confirmar exclusão',
      message:
          'Você tem certeza que deseja excluir esta transação? '
          'Esta ação não poderá ser desfeita.',
      onConfirm: () async {
        try {
          await _databaseService.deleteTransaction(transaction);

          refreshTransactions();

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
  void clearSearch() {
    searchController.clear();
  }

  //================================================================
  // Private Functions
  //================================================================

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
