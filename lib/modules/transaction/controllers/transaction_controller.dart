import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  // Streams
  late StreamSubscription _transactionSubscription;

  // List
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;

  //================================================================
  // Lifecycle Methods
  //================================================================

  @override
  void onInit() {
    super.onInit();

    _listenToTransactionStream();
  }

  @override
  void onClose() {
    _transactionSubscription.cancel();

    super.onClose();
  }

  //================================================================
  // Public Functions
  //================================================================
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

  //================================================================
  // Private Functions
  //================================================================

  void _listenToTransactionStream() {
    final transactionStream = _databaseService.getTransactionsStream();
    _transactionSubscription = transactionStream.listen((newTransactions) {
      transactions.assignAll(newTransactions);
    });
  }
}
