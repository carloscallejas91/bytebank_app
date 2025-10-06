import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/app/data/enums/transaction_type.dart';
import 'package:mobile_app/app/data/models/transaction_model.dart';
import 'package:mobile_app/app/services/auth_service.dart';
import 'package:mobile_app/app/services/database_service.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/app/services/storage_service.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';



class TransactionFormController extends GetxController {
  // Services
  final _databaseService = Get.find<DatabaseService>();
  final _storageService = Get.find<StorageService>();
  final _snackBarService = Get.find<SnackBarService>();

  // Form
  final formKey = GlobalKey<FormState>();

  // Controllers
  final descriptionController = TextEditingController();
  final valueController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );

  // Models
  final TransactionModel? editingTransaction;

  // Form parameters
  final selectedType = TransactionType.expense.obs;
  final selectedPaymentMethod = RxnString();

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

  // File
  final Rxn<File> selectedReceipt = Rxn<File>();
  final RxnString existingReceiptUrl = RxnString();

  // Conditionals
  final isLoading = false.obs;

  // Others
  final Uuid uuid = Uuid();

  // Constructor
  TransactionFormController() : editingTransaction = Get.arguments;

  //================================================================
  // Lifecycle Methods
  //================================================================

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

  //================================================================
  // Getters
  //================================================================

  bool get isEditMode => editingTransaction != null;

  List<String> get currentPaymentMethods {
    if (selectedType.value == TransactionType.expense) {
      return _expenseMethods;
    } else {
      return _incomeMethods;
    }
  }

  //================================================================
  // Public Functions
  //================================================================

  void setTransactionType(TransactionType type) {
    if (selectedType.value == type) return;

    selectedType.value = type;
    selectedPaymentMethod.value = null;
  }

  Future<void> saveTransaction() async {
    if (_isFormValid()) return;

    isLoading.value = true;

    try {
      String? finalReceiptUrl = existingReceiptUrl.value;
      final transactionId = editingTransaction?.id ?? uuid.v4();

      if (selectedReceipt.value != null) {
        final userId = Get.find<AuthService>().currentUser!.uid;
        finalReceiptUrl  = await _storageService.uploadTransactionReceipt(
          userId: userId,
          transactionId: transactionId,
          file: selectedReceipt.value!,
        );
      }

      final transaction = TransactionModel(
        id: editingTransaction?.id ?? uuid.v4(),
        type: selectedType.value,
        amount: valueController.numberValue,
        description: descriptionController.text,
        paymentMethod: selectedPaymentMethod.value!,
        receiptUrl: finalReceiptUrl,
        date: editingTransaction?.date ?? DateTime.now(),
      );

      if (isEditMode) {
        await _databaseService.updateTransaction(
          editingTransaction!,
          transaction,
        );
      } else {
        await _databaseService.addTransaction(transaction);
      }

      _handleSuccess(isUpdate: isEditMode);
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickReceipt() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      selectedReceipt.value = File(pickedFile.path);
    }
  }

  Future<void> viewReceipt() async {
    if (existingReceiptUrl.value != null) {
      final uri = Uri.parse(existingReceiptUrl.value!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _snackBarService.showError(title: 'Erro', message: 'Não foi possível abrir o link.');
      }
    }
  }

  void removeReceipt() {
    selectedReceipt.value = null;
    existingReceiptUrl.value = null;
  }

  //================================================================
  // Private Functions
  //================================================================

  void _prefillForm() {
    final TransactionModel transaction = editingTransaction!;

    valueController.updateValue(transaction.amount);
    descriptionController.text = transaction.description;
    selectedType.value = transaction.type;
    selectedPaymentMethod.value = transaction.paymentMethod;
    existingReceiptUrl.value = transaction.receiptUrl;
    selectedReceipt.value = null;
  }

  void _handleSuccess({bool isUpdate = false}) {
    final transactionListController = Get.find<TransactionController>();
    transactionListController.refreshTransactions();

    if (isUpdate) {
      Get.back();
    } else {
      _clearForm();
    }

    _snackBarService.showSuccess(
      title: 'Sucesso!',
      message: isUpdate
          ? 'Sua transação foi atualizada.'
          : 'Sua transação foi salva.',
    );
  }

  void _handleError(Object e) {
    _snackBarService.showError(
      title: 'Erro',
      message: 'Não foi possível salvar a transação. Tente novamente.',
    );
  }

  void _clearForm() {
    formKey.currentState?.reset();
    valueController.updateValue(0.0);
    descriptionController.clear();
    selectedPaymentMethod.value = null;
    selectedType.value = TransactionType.expense;
    selectedReceipt.value = null;
    existingReceiptUrl.value = null;
  }

  bool _isFormValid() {
    if (!formKey.currentState!.validate()) return true;

    return false;
  }
}
