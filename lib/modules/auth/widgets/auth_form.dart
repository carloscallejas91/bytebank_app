import 'package:flutter/material.dart';
import 'package:mobile_app/app/ui/widgets/custom_button.dart';
import 'package:mobile_app/app/ui/widgets/custom_text_field.dart';
import 'package:mobile_app/app/utils/app_validators.dart';

class AuthForm extends StatelessWidget {
  final Key formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final bool isPasswordHidden;
  final VoidCallback onSignIn;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onForgotPassword;

  const AuthForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.isPasswordHidden,
    required this.onSignIn,
    required this.onTogglePasswordVisibility,
    required this.onForgotPassword,
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
              Text('Faça login para acessar sua conta.'),
              const SizedBox(height: 32),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              Align(
                alignment: Alignment.centerRight,
                child: _buildForgotPasswordButton(),
              ),
              const SizedBox(height: 16),
              _buildSignInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(ThemeData theme) {
    return Row(
      children: [
        Text('Seja ', style: theme.textTheme.titleLarge),
        Text(
          'bem-vindo!',
          style: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
      hintText: '********',
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
      validator: AppValidators.password,
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: onForgotPassword,
      child: const Text('Esqueceu a senha?'),
    );
  }

  Widget _buildSignInButton() {
    return CustomButton(
      text: 'Entrar',
      isLoading: isLoading,
      onPressed: onSignIn,
    );
  }
}
