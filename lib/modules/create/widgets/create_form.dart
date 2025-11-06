import 'package:flutter/material.dart';
import 'package:mobile_app/app/ui/widgets/custom_button.dart';
import 'package:mobile_app/app/ui/widgets/custom_text_field.dart';
import 'package:mobile_app/app/utils/app_validators.dart';

class CreateForm extends StatelessWidget {
  final Key formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;
  final VoidCallback onCreateAccount;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;

  const CreateForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.isPasswordHidden,
    required this.isConfirmPasswordHidden,
    required this.onCreateAccount,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: formKey,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildWelcomeText(theme),
              const SizedBox(height: 16),
              const Text('Preencha os campos abaixo para criar sua conta.'),
              const SizedBox(height: 32),
              _buildNameField(),
              const SizedBox(height: 16),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 16),
              _buildConfirmPasswordField(),
              const SizedBox(height: 16),
              _buildCreateAccountButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(ThemeData theme) {
    return Row(
      children: [
        Text('Criar ', style: theme.textTheme.titleLarge),
        Text(
          'conta',
          style: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      controller: nameController,
      labelText: 'Nome',
      hintText: 'Como podemos te chamar?',
      prefixIcon: Icons.person_outline,
      validator: (value) => AppValidators.notEmpty(
        value,
        message: 'O campo de nome é obrigatório.',
      ),
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      controller: emailController,
      labelText: 'E-mail',
      hintText: 'seuemail@exemplo.com',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: AppValidators.email,
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      controller: passwordController,
      labelText: 'Senha',
      hintText: 'Crie uma senha forte',
      prefixIcon: Icons.lock_outline,
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

  Widget _buildConfirmPasswordField() {
    return CustomTextField(
      controller: confirmPasswordController,
      labelText: 'Confirmar Senha',
      hintText: 'Repita a senha',
      prefixIcon: Icons.lock_outline,
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

  Widget _buildCreateAccountButton() {
    return CustomButton(
      text: 'Criar Conta',
      isLoading: isLoading,
      onPressed: onCreateAccount,
    );
  }
}
