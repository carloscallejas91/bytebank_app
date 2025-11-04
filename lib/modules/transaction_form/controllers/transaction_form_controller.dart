import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';
import 'package:mobile_app/domain/usecases/generate_id_usecase.dart';
import 'package:mobile_app/domain/usecases/launch_url_usecase.dart';
import 'package:mobile_app/domain/usecases/pick_image_usecase.dart';
import 'package:mobile_app/domain/usecases/save_transaction_usecase.dart';
import 'package:mobile_app/domain/usecases/upload_receipt_usecase.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';

class TransactionFormController extends GetxController {
  // Services
  final _snackBarService = Get.find<SnackBarService>();

  // Repositories
  final _authRepository = Get.find<IAuthRepository>();

  // Use Cases
  final _uploadReceiptUseCase = Get.find<UploadReceiptUseCase>();
  final _pickImageUseCase = Get.find<PickImageUseCase>();
  final _launchUrlUseCase = Get.find<LaunchUrlUseCase>();
  final _generateIdUseCase = Get.find<GenerateIdUseCase>();
  final _saveTransactionUseCase = Get.find<SaveTransactionUseCase>();

  // Form Key
  final formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final descriptionController = TextEditingController();
  final valueController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );

  // Arguments
  final TransactionEntity? editingTransaction;

  // Form State
  final selectedType = TransactionType.expense.obs;
  final selectedPaymentMethod = RxnString();
  final Rxn<File> selectedReceipt = Rxn<File>();
  final RxnString existingReceiptUrl = RxnString();

  // UI State
  final isLoading = false.obs;

  // Constructor
  TransactionFormController()
    : editingTransaction = (Get.arguments is Map
          ? Get.arguments['transaction']
          : null);

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

  bool get isEditMode => editingTransaction != null;

  // UI Actions
  void setTransactionType(TransactionType type) {
    if (selectedType.value == type) return;
    selectedType.value = type;
    selectedPaymentMethod.value = null;
  }

  Future<void> saveTransaction() async {
    if (formKey.currentState?.validate() != true) return;

    final userId = _authRepository.currentUser?.uid;
    if (userId == null) return;

    isLoading.value = true;

    try {
      final transactionId = editingTransaction?.id ?? _generateIdUseCase.call();
      final receiptUrl = await _uploadReceiptIfNeeded(userId, transactionId);
      final transaction = _createTransactionEntity(transactionId, receiptUrl);

      await _saveTransactionUseCase.call(
        userId: userId,
        transaction: transaction,
        oldTransaction: editingTransaction,
      );

      _handleSuccess(isUpdate: isEditMode);
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickReceipt() async {
    final pickedFile = await _pickImageUseCase.call(ImageSource.gallery);
    if (pickedFile != null) {
      selectedReceipt.value = pickedFile;
    }
  }

  Future<void> viewReceipt() async {
    if (existingReceiptUrl.value != null) {
      try {
        await _launchUrlUseCase.call(existingReceiptUrl.value!);
      } catch (e) {
        _snackBarService.showError(
          title: 'Erro',
          message: 'Não foi possível abrir o comprovante.',
        );
      }
    }
  }

  void removeReceipt() {
    selectedReceipt.value = null;
    existingReceiptUrl.value = null;
  }

  // Internal Logic & Private Methods
  void _prefillForm() {
    final transaction = editingTransaction!;
    valueController.updateValue(transaction.amount);
    descriptionController.text = transaction.description;
    selectedType.value = transaction.type;
    selectedPaymentMethod.value = transaction.paymentMethod;
    existingReceiptUrl.value = transaction.receiptUrl;
    selectedReceipt.value = null;
  }

  Future<String?> _uploadReceiptIfNeeded(
    String userId,
    String transactionId,
  ) async {
    if (selectedReceipt.value != null) {
      return await _uploadReceiptUseCase.call(
        userId: userId,
        transactionId: transactionId,
        file: selectedReceipt.value!,
      );
    }
    return existingReceiptUrl.value;
  }

  TransactionEntity _createTransactionEntity(String id, String? receiptUrl) {
    return TransactionEntity(
      id: id,
      type: selectedType.value,
      amount: valueController.numberValue,
      description: descriptionController.text,
      paymentMethod: selectedPaymentMethod.value!,
      receiptUrl: receiptUrl,
      date: editingTransaction?.date ?? DateTime.now(),
    );
  }

  void _handleSuccess({bool isUpdate = false}) {
    if (Get.isRegistered<TransactionController>()) {
      Get.find<TransactionController>().refreshTransactions();
    }

    Get.back();

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
}
