import 'package:flutter/material.dart';
import 'package:mobile_app/app/ui/widgets/custom_button.dart';
import 'package:mobile_app/app/ui/widgets/custom_text_field.dart';
import 'package:mobile_app/app/utils/app_validators.dart';

class CreateForm extends StatelessWidget {
  final TextEditingController nameController;
  final String nameLabelText;
  final String nameHintText;
  final IconData namePrefixIcon;
  final TextEditingController emailController;
  final String emailLabelText;
  final String emailHintText;
  final IconData emailPrefixIcon;
  final TextEditingController passwordController;
  final String passwordLabelText;
  final String passwordHintText;
  final IconData passwordPrefixIcon;
  final TextEditingController confirmPasswordController;
  final String confirmPasswordLabelText;
  final String confirmPasswordHintText;
  final IconData confirmPasswordPrefixIcon;
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;

  const CreateForm({
    super.key,
    required this.nameController,
    required this.nameLabelText,
    required this.nameHintText,
    required this.namePrefixIcon,
    required this.emailController,
    required this.emailLabelText,
    required this.emailHintText,
    required this.emailPrefixIcon,
    required this.passwordController,
    required this.passwordLabelText,
    required this.passwordHintText,
    required this.passwordPrefixIcon,
    required this.confirmPasswordController,
    required this.confirmPasswordLabelText,
    required this.confirmPasswordHintText,
    required this.confirmPasswordPrefixIcon,
    required this.isPasswordHidden,
    required this.isConfirmPasswordHidden,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        _buildNameField(),
        _buildEmailField(),
        _buildPasswordField(),
        _buildConfirmPasswordField(),
      ],
    );
  }

  CustomTextField _buildNameField() {
    return CustomTextField(
      controller: nameController,
      labelText: nameLabelText,
      hintText: nameHintText,
      prefixIcon: namePrefixIcon,
      validator: (value) => AppValidators.notEmpty(
        value,
        message: 'O campo de nome é obrigatório.',
      ),
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
      validator: AppValidators.strongPassword,
    );
  }

  CustomTextField _buildConfirmPasswordField() {
    return CustomTextField(
      controller: confirmPasswordController,
      labelText: confirmPasswordLabelText,
      hintText: confirmPasswordHintText,
      prefixIcon: confirmPasswordPrefixIcon,
      isPassword: isConfirmPasswordHidden,
      suffixIcon: IconButton(
        icon: Icon(
          isConfirmPasswordHidden
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
        onPressed: onToggleConfirmPasswordVisibility,
      ),
      validator: (value) =>
          AppValidators.confirmPassword(passwordController.text, value),
    );
  }
}
