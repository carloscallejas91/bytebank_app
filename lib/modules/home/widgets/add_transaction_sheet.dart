import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/core/enums/transaction_type.dart';
import 'package:mobile_app/app/ui/widgets/custom_text_field.dart';
import 'package:mobile_app/app/utils/app_validators.dart';
import 'package:mobile_app/modules/home/controllers/add_transaction_controller.dart';

class AddTransactionSheet extends StatelessWidget {
  final AddTransactionController controller;

  const AddTransactionSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nova Transação', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              _buildTransactionForm(theme),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: controller.saveTransaction,
                child: const Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionForm(ThemeData theme) {
    return Form(
      key: controller.formKey,
      child: Column(
        spacing: 16,
        children: [
          Obx(
            () => SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(
                  value: TransactionType.expense,
                  label: Text('Saída'),
                  icon: Icon(Icons.arrow_downward),
                ),
                ButtonSegment(
                  value: TransactionType.income,
                  label: Text('Entrada'),
                  icon: Icon(Icons.arrow_upward),
                ),
              ],
              selected: {controller.selectedType.value},
              onSelectionChanged: (Set<TransactionType> newSelection) {
                controller.setTransactionType(newSelection.first);
              },
            ),
          ),
          CustomTextField(
            controller: controller.valueController,
            labelText: 'Valor',
            hintText: '0,00',
            prefixIcon: Icons.attach_money,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: AppValidators.currency,
          ),
          Obx(
            () => DropdownButtonFormField<String>(
              initialValue: controller.selectedCategory.value,
              decoration: InputDecoration(
                labelText: 'Categoria',
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              items: controller.categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (newValue) {
                controller.selectedCategory.value = newValue;
              },
              validator: (value) => AppValidators.notEmpty(
                value,
                message: 'Por favor, selecione uma categoria.',
              ),
            ),
          ),
          CustomTextField(
            controller: controller.descriptionController,
            labelText: 'Descrição',
            hintText: 'Super mercado, aluguel ...',
            prefixIcon: Icons.description_outlined,
            keyboardType: TextInputType.text,
            validator: AppValidators.notEmpty,
          ),
        ],
      ),
    );
  }
}
