import 'package:flutter/material.dart';
import 'package:mobile_app/app/ui/widgets/custom_text_field.dart';

class DescriptionField extends StatelessWidget {
  final TextEditingController descriptionController;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final FormFieldValidator<String>? validator;

  const DescriptionField({
    super.key,
    required this.descriptionController,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
   this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: descriptionController,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      keyboardType: TextInputType.text,
      validator: validator,
          // (value) =>
          // AppValidators.notEmpty(value, message: 'A descrição é obrigatória.'),
    );
  }
}
