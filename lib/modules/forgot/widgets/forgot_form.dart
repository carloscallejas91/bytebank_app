import 'package:flutter/material.dart';
import 'package:mobile_app/app/ui/widgets/custom_button.dart';
import 'package:mobile_app/app/ui/widgets/custom_text_field.dart';
import 'package:mobile_app/app/utils/app_validators.dart';

class ForgotForm extends StatelessWidget {
  final Key formKey;
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onSendEmail;

  const ForgotForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.isLoading,
    required this.onSendEmail,
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
              const Text(
                'Digite seu e-mail abaixo para receber um link de redefinição de senha.',
              ),
              const SizedBox(height: 32),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildSendButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(ThemeData theme) {
    return Row(
      children: [
        Text('Recuperar ', style: theme.textTheme.titleLarge),
        Text(
          'senha',
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

  Widget _buildSendButton() {
    return CustomButton(
      text: 'Recuperar',
      isLoading: isLoading,
      onPressed: onSendEmail,
    );
  }
}
