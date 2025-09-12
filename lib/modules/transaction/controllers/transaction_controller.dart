import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/data/enums/transaction_type.dart';
import 'package:mobile_app/app/data/models/transaction_model.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:uuid/uuid.dart';

class TransactionController extends GetxController {
  // Utils
  final SnackBarService snackBarService = Get.find();

  // List
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleTransactions();
  }

  void _loadSampleTransactions() {
    var uuid = Uuid();
    transactions.assignAll([
      TransactionModel(
        id: uuid.v4(),
        type: TransactionType.expense,
        description: 'Aluguel',
        paymentMethod: 'Boleto',
        amount: 1500.00,
        date: DateTime.now().subtract(Duration(days: 2)),
      ),
      TransactionModel(
        id: uuid.v4(),
        type: TransactionType.income,
        description: 'Salário de Setembro',
        paymentMethod: 'Deposito bancário',
        amount: 5000.00,
        date: DateTime.now().subtract(Duration(days: 5)),
      ),
      TransactionModel(
        id: uuid.v4(),
        type: TransactionType.expense,
        description: 'Supermercado',
        paymentMethod: 'Cartão de crédito',
        amount: 350.75,
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
    ]);
  }

  void editTransaction(String id) {
    debugPrint("Editar transação com ID: $id");
    snackBarService.showWarning(
      title: 'Em breve',
      message: 'A tela de edição será implementada aqui.',
    );
  }

  void deleteTransaction(String id) {
    debugPrint("Deletar transação com ID: $id");
    snackBarService.showSuccess(
      title: 'Sucesso!',
      message: 'Transação deletada.',
    );
  }
}
