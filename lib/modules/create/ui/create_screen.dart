import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/ui/constants/app_assets.dart';
import 'package:mobile_app/app/ui/widgets/custom_button.dart';
import 'package:mobile_app/app/ui/widgets/footer.dart';
import 'package:mobile_app/app/ui/widgets/header.dart';
import 'package:mobile_app/modules/create/controllers/create_controller.dart';
import 'package:mobile_app/modules/create/widgets/create_form.dart';

class CreateScreen extends GetView<CreateController> {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
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
                    _buildLogo(),
                    const SizedBox(height: 32),
                    _buildForm(),
                    const SizedBox(height: 24),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Image _buildLogo() {
    return Image.asset(AppAssets.logo);
  }

  Form _buildForm() {
    return Form(
      key: controller.formKey,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Get.theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            spacing: 16,
            children: [_buildHeader(), _buildCreateForm(), _buildCreateAccountButton(),],
          ),
        ),
      ),
    );
  }

  Header _buildHeader() {
    return Header(
      textMessage: 'Criar ',
      textBoldMessage: 'conta',
      description: 'Preencha os campos abaixo para criar sua conta.',
    );
  }

  Obx _buildCreateForm() {
    return Obx(
      () => CreateForm(
        nameController: controller.nameController,
        nameLabelText: 'Nome',
        nameHintText: 'Como podemos te chamar?',
        namePrefixIcon: Icons.person_outline,
        emailController: controller.emailController,
        emailLabelText: 'E-mail',
        emailHintText: 'seuemail@exemplo.com',
        emailPrefixIcon: Icons.email_outlined,
        passwordController: controller.passwordController,
        passwordLabelText: 'Senha',
        passwordHintText: 'Crie uma senha forte',
        passwordPrefixIcon: Icons.lock_outline,
        isPasswordHidden: controller.isPasswordHidden.value,
        confirmPasswordController: controller.confirmPasswordController,
        onTogglePasswordVisibility: controller.togglePasswordVisibility,
        confirmPasswordLabelText: 'Confirmar Senha',
        confirmPasswordHintText: 'Repita a senha',
        confirmPasswordPrefixIcon: Icons.lock_outline,
        isConfirmPasswordHidden: controller.isConfirmPasswordHidden.value,
        onToggleConfirmPasswordVisibility:
            controller.toggleConfirmPasswordVisibility,
      ),
    );
  }

  Obx _buildCreateAccountButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: CustomButton(
          text: 'Criar Conta',
          isLoading: controller.isLoading.value,
          onPressed: controller.createAccount,
        ),
      ),
    );
  }

  Footer _buildFooter() {
    return Footer(
      textMessage: 'Já tenho uma conta?',
      buttonText: 'Faça login',
      onCreateAccount: Get.back,
    );
  }
}
