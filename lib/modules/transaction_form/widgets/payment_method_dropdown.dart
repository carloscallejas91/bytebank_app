import 'package:flutter/material.dart';

class PaymentMethodDropdown extends StatelessWidget {
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  final IconData? prefixIcon;
  final String? hintText;

  const PaymentMethodDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: 'Selecione um método',
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        hintText: hintText,
      ),
      items: items.map((method) {
        return DropdownMenuItem(value: method, child: Text(method));
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
