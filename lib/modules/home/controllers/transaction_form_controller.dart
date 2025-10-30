import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';
import 'package:mobile_app/domain/usecases/add_transaction_usecase.dart';
import 'package:mobile_app/domain/usecases/update_transaction_usecase.dart';
import 'package:mobile_app/domain/usecases/upload_receipt_usecase.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class TransactionFormController extends GetxController {
  // Services
  final _snackBarService = Get.find<SnackBarService>();

  // Repositories & UseCases
  final _authRepository = Get.find<IAuthRepository>();
  final _addTransactionUseCase = Get.find<AddTransactionUseCase>();
  final _updateTransactionUseCase = Get.find<UpdateTransactionUseCase>();
  final _uploadReceiptUseCase = Get.find<UploadReceiptUseCase>();

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
  final TransactionEntity? editingTransaction;

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
  final Uuid uuid = const Uuid();

  // Constructor
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

  bool get isEditMode => editingTransaction != null;

  List<String> get currentPaymentMethods {
    return selectedType.value == TransactionType.expense
        ? _expenseMethods
        : _incomeMethods;
  }

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
      String? finalReceiptUrl = existingReceiptUrl.value;
      final transactionId = editingTransaction?.id ?? uuid.v4();

      if (selectedReceipt.value != null) {
        finalReceiptUrl = await _uploadReceiptUseCase.call(
          userId: userId,
          transactionId: transactionId,
          file: selectedReceipt.value!,
        );
      }

      final transaction = TransactionEntity(
        id: transactionId,
        type: selectedType.value,
        amount: valueController.numberValue,
        description: descriptionController.text,
        paymentMethod: selectedPaymentMethod.value!,
        receiptUrl: finalReceiptUrl,
        date: editingTransaction?.date ?? DateTime.now(),
      );

      if (isEditMode) {
        await _updateTransactionUseCase.call(
          userId: userId,
          oldTransaction: editingTransaction!,
          newTransaction: transaction,
        );
      } else {
        await _addTransactionUseCase.call(
          userId: userId,
          transaction: transaction,
        );
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
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
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
        _snackBarService.showError(
          title: 'Erro',
          message: 'Não foi possível abrir o link.',
        );
      }
    }
  }

  void removeReceipt() {
    selectedReceipt.value = null;
    existingReceiptUrl.value = null;
  }

  void _prefillForm() {
    final transaction = editingTransaction!;
    valueController.updateValue(transaction.amount);
    descriptionController.text = transaction.description;
    selectedType.value = transaction.type;
    selectedPaymentMethod.value = transaction.paymentMethod;
    existingReceiptUrl.value = transaction.receiptUrl;
    selectedReceipt.value = null;
  }

  void _handleSuccess({bool isUpdate = false}) {
    Get.find<TransactionController>().refreshTransactions();
    Get.back(); // Fecha o BottomSheet em ambos os casos (criação e edição)

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
