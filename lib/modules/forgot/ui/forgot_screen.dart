import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/ui/constants/app_assets.dart';
import 'package:mobile_app/app/ui/widgets/custom_button.dart';
import 'package:mobile_app/app/ui/widgets/footer.dart';
import 'package:mobile_app/app/ui/widgets/header.dart';
import 'package:mobile_app/modules/forgot/controllers/forgot_controller.dart';
import 'package:mobile_app/modules/forgot/widgets/forgot_form.dart';

class ForgotScreen extends GetView<ForgotController> {
  const ForgotScreen({super.key});

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
              _buildForgotForm(),
              _buildForgotButton(),
            ],
          ),
        ),
      ),
    );
  }

  Header _buildHeader() {
    return const Header(
      textMessage: 'Recuperar ',
      textBoldMessage: 'senha',
      description:
          'Digite seu e-mail abaixo para receber um link de '
          'redefinição de senha.',
    );
  }

  ForgotForm _buildForgotForm() {
    return ForgotForm(
      emailController: controller.emailController,
      emailLabelText: 'E-mail',
      emailHintText: 'seuemail@exemplo.com',
      emailPrefixIcon: Icons.email_outlined,
    );
  }

  Obx _buildForgotButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: CustomButton(
          text: 'Recuperar',
          isLoading: controller.isLoading.value,
          onPressed: controller.sendPasswordResetEmail,
        ),
      ),
    );
  }

  Footer _buildFooter() {
    return Footer(
      textMessage: 'Lembrou sua senha?',
      buttonText: 'Faça login',
      onCreateAccount: Get.back,
    );
  }
}
