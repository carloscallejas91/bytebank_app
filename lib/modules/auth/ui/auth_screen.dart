import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/ui/constants/app_assets.dart';
import 'package:mobile_app/app/ui/widgets/custom_button.dart';
import 'package:mobile_app/modules/auth/controllers/auth_controller.dart';
import 'package:mobile_app/app/ui/widgets/footer.dart';
import 'package:mobile_app/modules/auth/widgets/auth_form.dart';
import 'package:mobile_app/app/ui/widgets/header.dart';

class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});

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
            children: [
              _buildHeader(),
              _buildAuthForm(),
              _buildForgotPasswordButton(),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Header _buildHeader() {
    return const Header(
      textMessage: 'Seja ',
      textBoldMessage: 'bem-vindo!',
      description: 'Faça login para acessar sua conta.',
    );
  }

  Obx _buildAuthForm() {
    return Obx(
      () => AuthForm(
        emailController: controller.emailController,
        emailLabelText: 'E-mail',
        emailHintText: 'seuemail@exemplo.com',
        emailPrefixIcon: Icons.email_outlined,
        passwordController: controller.passwordController,
        passwordLabelText: 'Senha',
        passwordHintText: '********',
        passwordPrefixIcon: Icons.lock_outline,
        isPasswordHidden: controller.isPasswordHidden.value,
        onTogglePasswordVisibility: controller.togglePasswordVisibility,
      ),
    );
  }

  Align _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: controller.navigateToForgotPassword,
        child: Text('Esqueceu a senha?'),
      ),
    );
  }

  Obx _buildLoginButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: CustomButton(
          text: 'Entrar',
          isLoading: controller.isLoading.value,
          onPressed: controller.signInWithEmail,
        ),
      ),
    );
  }

  Footer _buildFooter() {
    return Footer(
      textMessage: 'Não tem uma conta?',
      buttonText: 'Crie uma agora!',
      onCreateAccount: controller.navigateToCreateAccount,
    );
  }
}
