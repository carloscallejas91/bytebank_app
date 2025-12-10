import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/ui/widgets/custom_text_field.dart';
import 'package:mobile_app/app/utils/app_validators.dart';

class AuthForm extends StatelessWidget {
  final TextEditingController emailController;
  final String emailLabelText;
  final String emailHintText;
  final IconData emailPrefixIcon;
  final TextEditingController passwordController;
  final String passwordLabelText;
  final String passwordHintText;
  final IconData passwordPrefixIcon;
  final bool isPasswordHidden;
  final VoidCallback onTogglePasswordVisibility;

  const AuthForm({
    super.key,
    required this.emailController,
    required this.emailLabelText,
    required this.emailHintText,
    required this.emailPrefixIcon,
    required this.passwordController,
    required this.isPasswordHidden,
    required this.passwordLabelText,
    required this.passwordHintText,
    required this.passwordPrefixIcon,
    required this.onTogglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [_buildEmailField(), _buildPasswordField()],
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      controller: emailController,
      labelText: emailLabelText,
      hintText: emailHintText,
      prefixIcon: emailPrefixIcon,
      keyboardType: TextInputType.emailAddress,
      validator: AppValidators.email,
    );
  }

  CustomTextField _buildPasswordField() {
    return CustomTextField(
      controller: passwordController,
      labelText: passwordLabelText,
      hintText: passwordHintText,
      prefixIcon: passwordPrefixIcon,
      isPassword: isPasswordHidden,
      suffixIcon: IconButton(
        icon: Icon(
          isPasswordHidden
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
        onPressed: onTogglePasswordVisibility,
      ),
      validator: AppValidators.password,
    );
  }
}
