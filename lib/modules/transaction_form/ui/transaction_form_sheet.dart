import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/ui/widgets/custom_button.dart';
import 'package:mobile_app/app/ui/widgets/custom_text_field.dart';
import 'package:mobile_app/app/utils/app_validators.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';
import 'package:mobile_app/modules/transaction_form/controllers/transaction_form_controller.dart';
import 'package:path/path.dart' as p;

class TransactionFormSheet extends GetView<TransactionFormController> {
  const TransactionFormSheet({super.key});

  static final List<String> _expenseMethods = [
    'Boleto',
    'Cartão de débito',
    'Cartão de crédito',
    'Pix',
    'Outro',
  ];

  static final List<String> _incomeMethods = [
    'Salário',
    'Depósito bancário',
    'Reembolso',
    'Pix',
    'Outro',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.isEditMode ? 'Editar transação' : 'Nova transação',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              _buildTypeSelector(
                selectedType: controller.selectedType,
                onTypeChanged: controller.setTransactionType,
              ),
              const SizedBox(height: 16),
              _buildValueField(valueController: controller.valueController),
              const SizedBox(height: 16),
              _buildPaymentMethodDropdown(
                selectedType: controller.selectedType,
                selectedPaymentMethod: controller.selectedPaymentMethod,
                onPaymentMethodChanged: (newValue) =>
                    controller.selectedPaymentMethod.value = newValue,
              ),
              const SizedBox(height: 16),
              _buildDescriptionField(
                descriptionController: controller.descriptionController,
              ),
              const SizedBox(height: 16),
              _buildReceiptPicker(
                selectedReceipt: controller.selectedReceipt,
                existingReceiptUrl: controller.existingReceiptUrl,
                onPickReceipt: controller.pickReceipt,
                onViewReceipt: controller.viewReceipt,
                onRemoveReceipt: controller.removeReceipt,
                theme: theme,
              ),
              const SizedBox(height: 32),
              _buildSaveButton(
                isLoading: controller.isLoading,
                onSave: controller.saveTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector({
    required Rx<TransactionType> selectedType,
    required ValueChanged<TransactionType> onTypeChanged,
  }) {
    return Obx(
      () => SegmentedButton<TransactionType>(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(
            value: TransactionType.income,
            label: Text('Entrada'),
            icon: Icon(Icons.arrow_upward),
          ),
          ButtonSegment(
            value: TransactionType.expense,
            label: Text('Saída'),
            icon: Icon(Icons.arrow_downward),
          ),
        ],
        selected: {selectedType.value},
        onSelectionChanged: (newSelection) => onTypeChanged(newSelection.first),
      ),
    );
  }

  Widget _buildValueField({
    required MoneyMaskedTextController valueController,
  }) {
    return CustomTextField(
      controller: valueController,
      labelText: 'Valor',
      hintText: 'R\$0,00',
      prefixIcon: Icons.attach_money,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (valueController.numberValue <= 0) {
          return 'Por favor, insira um valor maior que zero.';
        }
        return null;
      },
    );
  }

  Widget _buildPaymentMethodDropdown({
    required Rx<TransactionType> selectedType,
    required RxnString selectedPaymentMethod,
    required ValueChanged<String?> onPaymentMethodChanged,
  }) {
    return Obx(() {
      final isExpense = selectedType.value == TransactionType.expense;
      final currentPaymentMethods = isExpense
          ? _expenseMethods
          : _incomeMethods;

      return DropdownButtonFormField<String>(
        key: ValueKey('payment_method_${selectedType.value}'),
        initialValue: selectedPaymentMethod.value,
        hint: Text(
          isExpense
              ? 'Boleto, Cartão de débito, etc...'
              : 'Salário, Pix, etc...',
        ),
        decoration: InputDecoration(
          labelText: 'Selecione um método',
          prefixIcon: Icon(
            isExpense ? Icons.payment_outlined : Icons.source_outlined,
          ),
        ),
        items: currentPaymentMethods
            .map(
              (method) => DropdownMenuItem(value: method, child: Text(method)),
            )
            .toList(),
        onChanged: onPaymentMethodChanged,
        validator: (value) => AppValidators.notEmpty(
          value,
          message: 'Por favor, selecione um método.',
        ),
      );
    });
  }

  Widget _buildDescriptionField({
    required TextEditingController descriptionController,
  }) {
    return CustomTextField(
      controller: descriptionController,
      labelText: 'Descrição',
      hintText: 'Descrição',
      prefixIcon: Icons.description_outlined,
      keyboardType: TextInputType.text,
      validator: (value) =>
          AppValidators.notEmpty(value, message: 'A descrição é obrigatória.'),
    );
  }

  Widget _buildReceiptPicker({
    required Rxn<File> selectedReceipt,
    required RxnString existingReceiptUrl,
    required VoidCallback onPickReceipt,
    required VoidCallback onViewReceipt,
    required VoidCallback onRemoveReceipt,
    required ThemeData theme,
  }) {
    return Obx(() {
      if (selectedReceipt.value != null) {
        return Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                p.basename(controller.selectedReceipt.value!.path),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onRemoveReceipt,
            ),
          ],
        );
      } else if (existingReceiptUrl.value != null &&
          existingReceiptUrl.value!.isNotEmpty) {
        return Row(
          children: [
            const Icon(Icons.cloud_done, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(child: Text('Comprovante salvo')),
            TextButton(onPressed: onViewReceipt, child: const Text('Ver')),
            IconButton(
              icon: Icon(Icons.close, color: theme.colorScheme.error),
              onPressed: onRemoveReceipt,
            ),
          ],
        );
      } else {
        return OutlinedButton.icon(
          icon: Icon(Icons.attach_file, color: theme.colorScheme.onSurface),
          label: Text(
            'Anexar',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
          onPressed: onPickReceipt,
        );
      }
    });
  }

  Widget _buildSaveButton({
    required RxBool isLoading,
    required VoidCallback onSave,
  }) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: CustomButton(
          text: 'Salvar',
          isLoading: isLoading.value,
          onPressed: onSave,
        ),
      ),
    );
  }
}
