import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/app/ui/widgets/app_dialogs.dart';
import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/domain/entities/transaction_filter_model.dart';
import 'package:mobile_app/domain/enums/sort_order.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';
import 'package:mobile_app/domain/usecases/delete_transaction_usecase.dart';
import 'package:mobile_app/domain/usecases/get_transactions_usecase.dart';
import 'package:mobile_app/modules/home/widgets/transaction_form_sheet.dart';
import 'package:mobile_app/modules/transaction/widgets/transaction_options_sheet.dart';

class TransactionController extends GetxController {
  // Services
  final _snackBarService = Get.find<SnackBarService>();

  // Repositories & UseCases
  final _authRepository = Get.find<IAuthRepository>();
  final _getTransactionsUseCase = Get.find<GetTransactionsUseCase>();
  final _deleteTransactionUseCase = Get.find<DeleteTransactionUseCase>();

  // UI Controllers
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  // State
  final RxList<TransactionEntity> transactions = <TransactionEntity>[].obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final Rx<TransactionFilter> filter = TransactionFilter().obs;
  final Rx<SortOrder> sortOrder = SortOrder.desc.obs;

  // Internals
  DocumentSnapshot? _lastDocument;
  Timer? _debounce;

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

  Future<void> refreshTransactions() async {
    _lastDocument = null;
    hasMore.value = true;
    transactions.clear();
    await fetchFirstPage();
  }

  Future<void> fetchFirstPage() async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) return;

    isLoadingMore.value = true;
    try {
      final pageResult = await _getTransactionsUseCase.call(
        userId: userId,
        limit: 10,
        filter: filter.value,
        sortOrder: sortOrder.value,
      );
      _lastDocument = pageResult.lastDocument;
      transactions.assignAll(pageResult.transactions);
      hasMore.value = pageResult.transactions.length == 10;
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
    final userId = _authRepository.currentUser?.uid;
    if (isLoadingMore.value || !hasMore.value || userId == null) return;

    isLoadingMore.value = true;
    try {
      final pageResult = await _getTransactionsUseCase.call(
        userId: userId,
        limit: 10,
        startAfter: _lastDocument,
        filter: filter.value,
        sortOrder: sortOrder.value,
      );
      if (pageResult.transactions.isNotEmpty) {
        _lastDocument = pageResult.lastDocument;
        transactions.addAll(pageResult.transactions);
      }
      hasMore.value = pageResult.transactions.length == 10;
    } catch (e) {
      _snackBarService.showError(
        title: 'Erro',
        message: 'Não foi possível buscar mais transações.',
      );
    } finally {
      isLoadingMore.value = false;
    }
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
          transactions.removeWhere((t) => t.id == transaction.id);
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
    if (filter.value.type == type) {
      filter.value.type = null;
    } else {
      filter.value.type = type;
    }
    filter.refresh();
    refreshTransactions();
  }

  void toggleSortOrder() {
    sortOrder.value = (sortOrder.value == SortOrder.desc)
        ? SortOrder.asc
        : SortOrder.desc;
    refreshTransactions();
  }

  void showOptionsSheet(TransactionEntity transaction) {
    Get.bottomSheet(
      TransactionOptionsSheet(transaction: transaction),
      backgroundColor: Get.theme.colorScheme.surface,
    );
  }

  void editTransaction(TransactionEntity transactionToEdit) {
    Get.bottomSheet(
      const TransactionFormSheet(),
      backgroundColor: Get.theme.colorScheme.surface,
      isScrollControlled: true,
      settings: RouteSettings(arguments: transactionToEdit),
    );
  }

  void clearSearch() {
    searchController.clear();
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
