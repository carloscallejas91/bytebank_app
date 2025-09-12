import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/data/enums/transaction_type.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/app/utils/date_formatter.dart';

class AddTransactionController extends GetxController {
  // Utils
  final SnackBarService snackBarService = Get.find();

  // Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  final valueController = TextEditingController();
  final descriptionController = TextEditingController();

  // Form Fields
  final selectedType = TransactionType.expense.obs;
  final selectedCategory = RxnString();
  final List<String> categories = [
    '',
    'Boleto',
    'Cartão de débito',
    'Cartão de crédito',
    'Deposito bancário',
    'Pix',
    'Outro',
  ];

  // Conditionals
  final RxBool isLoading = false.obs;

  bool isFormValid() {
    if (!formKey.currentState!.validate()) return true;

    return false;
  }

  void setTransactionType(TransactionType type) {
    selectedType.value = type;
  }

  void saveTransaction() {
    if (isFormValid()) return;

    final type = selectedType.value.toString().split('.').last;
    final value =
        double.tryParse(valueController.text.replaceAll(',', '.')) ?? 0.0;
    final category = selectedCategory.value;
    final description = descriptionController.text;
    final date = DateTime.now();

    debugPrint('--- Nova Transação Salva ---');
    debugPrint('Tipo: $type');
    debugPrint('Valor: $value');
    debugPrint('Categoria: $category');
    debugPrint('Descrição: $description');
    debugPrint('Data: ${DateFormatter.formatSimpleDate(date)}');
    debugPrint('-----------------------------');

    Get.back();

    snackBarService.showSuccess(
      title: 'Sucesso!',
      message: 'Sua transação foi salva.',
    );

    clearForm();
  }

  void clearForm() {
    valueController.clear();
    selectedCategory.value = '';
    descriptionController.clear();
    selectedType.value = TransactionType.expense;
  }

  @override
  void onClose() {
    valueController.dispose();

    descriptionController.dispose();
    super.onClose();
  }
}
