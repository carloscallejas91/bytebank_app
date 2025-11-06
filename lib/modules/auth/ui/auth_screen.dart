import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/modules/auth/controllers/auth_controller.dart';
import 'package:mobile_app/modules/auth/widgets/auth_footer.dart';
import 'package:mobile_app/modules/auth/widgets/auth_form.dart';
import 'package:mobile_app/modules/auth/widgets/auth_header.dart';

class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    const AuthHeader(),
                    const SizedBox(height: 16),
                    Obx(
                      () => AuthForm(
                        formKey: controller.formKey,
                        emailController: controller.emailController,
                        passwordController: controller.passwordController,
                        isLoading: controller.isLoading.value,
                        isPasswordHidden: controller.isPasswordHidden.value,
                        onSignIn: controller.signInWithEmail,
                        onTogglePasswordVisibility:
                            controller.togglePasswordVisibility,
                        onForgotPassword: controller.navigateToForgotPassword,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AuthFooter(
                      onCreateAccount: controller.navigateToCreateAccount,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
