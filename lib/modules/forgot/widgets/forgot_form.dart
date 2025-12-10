import 'package:flutter/material.dart';
import 'package:mobile_app/app/ui/widgets/custom_button.dart';
import 'package:mobile_app/app/ui/widgets/custom_text_field.dart';
import 'package:mobile_app/app/utils/app_validators.dart';

class ForgotForm extends StatelessWidget {
  final TextEditingController emailController;
  final String emailLabelText;
  final String emailHintText;
  final IconData emailPrefixIcon;

  const ForgotForm({
    super.key,
    required this.emailController,
    required this.emailLabelText,
    required this.emailHintText,
    required this.emailPrefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [_buildEmailField()],
    );
  }

  CustomTextField _buildEmailField() {
    return CustomTextField(
      controller: emailController,
      labelText: emailLabelText,
      hintText: emailHintText,
      prefixIcon: emailPrefixIcon,
      keyboardType: TextInputType.emailAddress,
      validator: AppValidators.email,
    );
  }
}
