import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/data/enums/transaction_type.dart';
import 'package:mobile_app/app/data/models/transaction_model.dart';
import 'package:mobile_app/app/services/database_service.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:uuid/uuid.dart';

class TransactionFormController extends GetxController {
  // --- DEPENDÊNCIAS (SERVICES) ---
  final DatabaseService _databaseService = Get.find();
  final SnackBarService _snackBarService = Get.find();

  // --- GERENCIADORES DA UI (UI CONTROLLERS) ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final MoneyMaskedTextController valueController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );

  // --- ESTADO REATIVO ---
  final Rx<TransactionType> selectedType = TransactionType.expense.obs;
  final RxnString selectedPaymentMethod = RxnString();
  final RxBool isLoading = false.obs;

  // --- PROPRIEDADES INTERNAS --
  final Uuid uuid = Uuid();
  final TransactionModel? editingTransaction;
  final List<String> _expenseMethods = [
    'Boleto',
    'Cartão de débito',
    'Cartão de crédito',
    'Pix',
    'Outro',
  ];
  final List<String> _incomeMethods = [
    'Salário',
    'Depósito bancário',
    'Reembolso',
    'Pix',
    'Outro',
  ];

  // --- GETTERS ---
  bool get isEditMode => editingTransaction != null;

  List<String> get currentPaymentMethods {
    if (selectedType.value == TransactionType.expense) {
      return _expenseMethods;
    } else {
      return _incomeMethods;
    }
  }

  TransactionFormController() : editingTransaction = Get.arguments;

  @override
  void onInit() {
    super.onInit();

    if (isEditMode) _prefillForm();
  }

  @override
  void onClose() {
    valueController.dispose();
    descriptionController.dispose();

    super.onClose();
  }

  void _prefillForm() {
    final TransactionModel transaction = editingTransaction!;

    valueController.updateValue(transaction.amount);
    descriptionController.text = transaction.description;
    selectedType.value = transaction.type;
    selectedPaymentMethod.value = transaction.paymentMethod;
  }

  void setTransactionType(TransactionType type) {
    if (selectedType.value == type) return;

    selectedType.value = type;
    selectedPaymentMethod.value = null;
  }

  Future<void> saveTransaction() async {
    if (isFormValid()) return;

    isLoading.value = true;

    try {
      if (isEditMode) {
        final updatedTransaction = TransactionModel(
          id: editingTransaction!.id,
          type: selectedType.value,
          amount: valueController.numberValue,
          description: descriptionController.text,
          paymentMethod: selectedPaymentMethod.value!,
          date: editingTransaction!.date,
        );

        await _databaseService.updateTransaction(updatedTransaction);

        _handleSuccess(isUpdate: true);
      } else {
        final newTransaction = _buildTransactionModel();

        await _databaseService.addTransaction(newTransaction);

        _handleSuccess();
      }
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  TransactionModel _buildTransactionModel() {
    return TransactionModel(
      id: uuid.v4(),
      type: selectedType.value,
      amount: valueController.numberValue,
      description: descriptionController.text,
      paymentMethod: selectedPaymentMethod.value!,
      date: DateTime.now(),
    );
  }

  void _handleSuccess({bool isUpdate = false}) {
    if (isUpdate) {
      Get.back();

      _snackBarService.showSuccess(
        title: 'Sucesso!',
        message: 'Sua transação foi atualizada.',
      );
    } else {
      clearForm();

      _snackBarService.showSuccess(
        title: 'Sucesso!',
        message: 'Sua transação foi salva.',
      );
    }
  }

  void _handleError(Object e) {
    _snackBarService.showError(
      title: 'Erro',
      message: 'Não foi possível salvar a transação. Tente novamente.',
    );
  }

  void clearForm() {
    formKey.currentState?.reset();
    valueController.updateValue(0.0);
    descriptionController.clear();
    selectedPaymentMethod.value = null;
    selectedType.value = TransactionType.expense;
  }

  bool isFormValid() {
    if (!formKey.currentState!.validate()) return true;

    return false;
  }
}
