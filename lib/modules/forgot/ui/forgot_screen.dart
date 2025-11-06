import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/modules/forgot/controllers/forgot_controller.dart';
import 'package:mobile_app/modules/forgot/widgets/forgot_footer.dart';
import 'package:mobile_app/modules/forgot/widgets/forgot_form.dart';
import 'package:mobile_app/modules/forgot/widgets/forgot_header.dart';

class ForgotScreen extends GetView<ForgotController> {
  const ForgotScreen({super.key});

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
                    const ForgotHeader(),
                    const SizedBox(height: 16),
                    Obx(
                      () => ForgotForm(
                        formKey: controller.formKey,
                        emailController: controller.emailController,
                        isLoading: controller.isLoading.value,
                        onSendEmail: controller.sendPasswordResetEmail,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ForgotFooter(onLogin: Get.back),
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
