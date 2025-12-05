import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mobile_app/app/ui/widgets/custom_text_field.dart';

class ValueField extends StatelessWidget {
  final MoneyMaskedTextController valueController;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final FormFieldValidator<String>? validator;

  const ValueField({
    super.key,
    required this.valueController,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: valueController,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: validator,
    );
  }
}