import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/data/models/transaction_model.dart';
import 'package:mobile_app/app/services/database_service.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/app/ui/widgets/app_dialogs.dart';
import 'package:mobile_app/modules/home/widgets/transaction_form_sheet.dart';

class TransactionController extends GetxController {
  // --- DEPENDÊNCIAS (SERVICES) ---
  final DatabaseService _databaseService = Get.find();
  final SnackBarService snackBarService = Get.find();

  // --- PROPRIEDADES INTERNAS ---
  late StreamSubscription _transactionSubscription;

  // --- ESTADO REATIVO DA UI ---
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;

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

  void _listenToTransactionStream() {
    final transactionStream = _databaseService.getTransactionsStream();
    _transactionSubscription = transactionStream.listen((newTransactions) {
      transactions.assignAll(newTransactions);
    });
  }

  void editTransaction(String id) {
    final TransactionModel? transactionToEdit = transactions.firstWhereOrNull(
      (t) => t.id == id,
    );

    if (transactionToEdit == null) {
      snackBarService.showError(
        title: 'Erro',
        message: 'Transação não encontrada.',
      );

      return;
    }

    Get.bottomSheet(
      TransactionFormSheet(),
      backgroundColor: Get.theme.colorScheme.surface,
      isScrollControlled: true,
      settings: RouteSettings(arguments: transactionToEdit),
    );
  }

  void deleteTransaction(String id) {
    AppDialogs.showConfirmationDialog(
      title: 'Confirmar Exclusão',
      message:
          'Você tem certeza que deseja deletar esta transação? Esta ação não pode ser desfeita.',
      onConfirm: () async {
        try {
          await _databaseService.deleteTransaction(id);

          snackBarService.showSuccess(
            title: 'Sucesso!',
            message: 'Transação deletada.',
          );
        } catch (e) {
          snackBarService.showError(
            title: 'Erro',
            message: 'Não foi possível deletar a transação.',
          );
        }
      },
    );
  }
}
