import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/ui/constants/app_assets.dart';
import 'package:mobile_app/app/ui/widgets/custom_button.dart';
import 'package:mobile_app/app/ui/widgets/custom_text_field.dart';
import 'package:mobile_app/app/utils/app_validators.dart';
import 'package:mobile_app/modules/create/controllers/create_controller.dart';

class CreateScreen extends GetView<CreateController> {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(theme),
                    const SizedBox(height: 16),
                    _buildForm(controller, theme),
                    const SizedBox(height: 24),
                    _buildFooter(theme),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Image.asset(AppAssets.logo);
  }

  Widget _buildForm(CreateController controller, ThemeData theme) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text('Criar ', style: theme.textTheme.titleLarge),
                      Text(
                        'conta',
                        style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Preencha os campos abaixo para criar sua conta.'),
                  SizedBox(height: 32),
                  CustomTextField(
                    controller: controller.nameController,
                    labelText: 'Nome',
                    hintText: 'Como podemos te chamar?',
                    prefixIcon: Icons.person_outline,
                    validator: (value) => AppValidators.notEmpty(
                      value,
                      message: 'O campo de nome é obrigatório.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: controller.emailController,
                    labelText: 'E-mail',
                    hintText: 'seuemail@exemplo.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: AppValidators.email,
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => CustomTextField(
                      controller: controller.passwordController,
                      labelText: 'Senha',
                      hintText: 'Crie uma senha forte',
                      prefixIcon: Icons.lock_outline,
                      isPassword: controller.isPasswordHidden.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      validator: AppValidators.strongPassword,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => CustomTextField(
                      controller: controller.confirmPasswordController,
                      labelText: 'Confirmar Senha',
                      hintText: 'Repita a senha',
                      prefixIcon: Icons.lock_outline,
                      isPassword: controller.isConfirmPasswordHidden.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordHidden.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                      validator: (value) => AppValidators.confirmPassword(
                        controller.passwordController.text,
                        value,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => CustomButton(
                      text: 'Criar Conta',
                      isLoading: controller.isLoading.value,
                      onPressed: controller.createAccount,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Já tenho uma conta?'),
        TextButton(onPressed: Get.back, child: const Text('Login')),
      ],
    );
  }
}
