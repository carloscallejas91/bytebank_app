import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/utils/app_validators.dart';
import 'package:mobile_app/domain/enums/receipt_picker_state.dart';
import 'package:mobile_app/modules/transaction_form/controllers/transaction_form_controller.dart';
import 'package:mobile_app/modules/transaction_form/widgets/description_field.dart';
import 'package:mobile_app/modules/transaction_form/widgets/payment_method_dropdown.dart';
import 'package:mobile_app/modules/transaction_form/widgets/receipt_picker.dart';
import 'package:mobile_app/modules/transaction_form/widgets/save_button.dart';
import 'package:mobile_app/modules/transaction_form/widgets/type_selector.dart';
import 'package:mobile_app/modules/transaction_form/widgets/value_field.dart';
import 'package:path/path.dart' as p;

class TransactionFormSheet extends GetView<TransactionFormController> {
  const TransactionFormSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildTypeSelector(),
              const SizedBox(height: 16),
              _buildValueField(),
              const SizedBox(height: 16),
              _buildPaymentMethodDropdown(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 16),
              _buildReceiptPicker(),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Text _buildHeader() {
    return Text(
      controller.isEditMode ? 'Editar transação' : 'Nova transação',
      style: Get.theme.textTheme.headlineSmall,
    );
  }

  Obx _buildTypeSelector() {
    return Obx(
      () => TypeSelector(
        incomeLabel: 'Entrada',
        expensesLabel: 'Saída',
        selectedType: controller.selectedType.value,
        onTypeChanged: controller.setTransactionType,
      ),
    );
  }

  ValueField _buildValueField() {
    return ValueField(
      valueController: controller.valueController,
      labelText: 'Valor',
      hintText: 'R\$0,00',
      prefixIcon: Icons.attach_money,
      validator: (_) =>
          AppValidators.currencyGreaterThanZero(controller.valueController),
    );
  }

  Obx _buildPaymentMethodDropdown() {
    return Obx(() {
      return PaymentMethodDropdown(
        labelText: 'Selecione um método',
        items: controller.currentPaymentMethods,
        value: controller.selectedPaymentMethod.value,
        prefixIcon: controller.paymentMethodPrefixIcon,
        hintText: controller.paymentMethodHintText,
        onChanged: (newValue) {
          controller.selectedPaymentMethod.value = newValue;
        },
        validator: (value) => AppValidators.notEmpty(
          value,
          message: 'Por favor, selecione um método.',
        ),
      );
    });
  }

  DescriptionField _buildDescriptionField() {
    return DescriptionField(
      descriptionController: controller.descriptionController,
      labelText: 'Descrição',
      hintText: 'Descrição',
      prefixIcon: Icons.description_outlined,
      validator: (value) =>
          AppValidators.notEmpty(value, message: 'A descrição é obrigatória.'),
    );
  }

  Obx _buildReceiptPicker() {
    return Obx(() {
      final state = controller.receiptPickerState;
      switch (state) {
        case ReceiptPickerState.localFile:
          return ReceiptPicker.localFile(
            fileName: p.basename(controller.selectedReceipt.value!.path),
            onRemoveReceipt: controller.removeReceipt,
          );
        case ReceiptPickerState.existingReceipt:
          return ReceiptPicker.existingReceipt(
            onViewReceipt: controller.viewReceipt,
            onRemoveReceipt: controller.removeReceipt,
          );
        case ReceiptPickerState.attach:
          return ReceiptPicker.attach(onPickReceipt: controller.pickReceipt);
      }
    });
  }

  Obx _buildSaveButton() {
    return Obx(
      () => SaveButton(
        textButton: 'Salvar',
        isLoading: controller.isLoading.value,
        onSave: controller.saveTransaction,
      ),
    );
  }
}
