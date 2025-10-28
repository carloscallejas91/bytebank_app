import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/ui/widgets/custom_button.dart';
import 'package:mobile_app/app/ui/widgets/custom_text_field.dart';
import 'package:mobile_app/app/utils/app_validators.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';
import 'package:mobile_app/modules/home/controllers/transaction_form_controller.dart';
import 'package:path/path.dart' as p;

class TransactionFormSheet extends StatelessWidget {
  const TransactionFormSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionFormController());
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
              _buildTypeSelector(controller),
              const SizedBox(height: 16),
              _buildValueField(controller),
              const SizedBox(height: 16),
              _buildPaymentMethodDropdown(controller),
              const SizedBox(height: 16),
              _buildDescriptionField(controller),
              const SizedBox(height: 16),
              _buildReceiptPicker(controller, theme),
              const SizedBox(height: 32),
              _buildSaveButton(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector(TransactionFormController controller) {
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
        selected: {controller.selectedType.value},
        onSelectionChanged: (newSelection) =>
            controller.setTransactionType(newSelection.first),
      ),
    );
  }

  Widget _buildValueField(TransactionFormController controller) {
    return CustomTextField(
      controller: controller.valueController,
      labelText: 'Valor',
      hintText: 'R\$0,00',
      prefixIcon: Icons.attach_money,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (controller.valueController.numberValue <= 0) {
          return 'Por favor, insira um valor maior que zero.';
        }
        return null;
      },
    );
  }

  Widget _buildPaymentMethodDropdown(TransactionFormController controller) {
    return Obx(() {
      final isExpense =
          controller.selectedType.value == TransactionType.expense;
      return DropdownButtonFormField<String>(
        key: ValueKey('payment_method_${controller.selectedType.value}'),
        initialValue: controller.selectedPaymentMethod.value,
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
        items: controller.currentPaymentMethods
            .map(
              (method) => DropdownMenuItem(value: method, child: Text(method)),
            )
            .toList(),
        onChanged: (newValue) =>
            controller.selectedPaymentMethod.value = newValue,
        validator: (value) => AppValidators.notEmpty(
          value,
          message: 'Por favor, selecione um método.',
        ),
      );
    });
  }

  Widget _buildDescriptionField(TransactionFormController controller) {
    return CustomTextField(
      controller: controller.descriptionController,
      labelText: 'Descrição',
      hintText: 'Descrição',
      prefixIcon: Icons.description_outlined,
      keyboardType: TextInputType.text,
      validator: (value) =>
          AppValidators.notEmpty(value, message: 'A descrição é obrigatória.'),
    );
  }

  Widget _buildReceiptPicker(
    TransactionFormController controller,
    ThemeData theme,
  ) {
    return Obx(() {
      if (controller.selectedReceipt.value != null) {
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
              onPressed: controller.removeReceipt,
            ),
          ],
        );
      }
      else if (controller.existingReceiptUrl.value != null &&
          controller.existingReceiptUrl.value!.isNotEmpty) {
        return Row(
          children: [
            const Icon(Icons.cloud_done, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(child: Text('Comprovante salvo')),
            TextButton(
              onPressed: controller.viewReceipt,
              child: const Text('Ver'),
            ),
            IconButton(
              icon: Icon(Icons.close, color: theme.colorScheme.error),
              onPressed: controller.removeReceipt,
            ),
          ],
        );
      }
      else {
        return OutlinedButton.icon(
          icon: Icon(Icons.attach_file, color: theme.colorScheme.onSurface,),
          label: Text('Anexar', style: TextStyle(color: theme.colorScheme.onSurface),),
          onPressed: controller.pickReceipt,
        );
      }
    });
  }

  Widget _buildSaveButton(TransactionFormController controller) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: CustomButton(
          text: 'Salvar',
          isLoading: controller.isLoading.value,
          onPressed: controller.saveTransaction,
        ),
      ),
    );
  }
}
