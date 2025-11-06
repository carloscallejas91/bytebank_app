import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/modules/create/controllers/create_controller.dart';
import 'package:mobile_app/modules/create/widgets/create_footer.dart';
import 'package:mobile_app/modules/create/widgets/create_form.dart';
import 'package:mobile_app/modules/create/widgets/create_header.dart';

class CreateScreen extends GetView<CreateController> {
  const CreateScreen({super.key});

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
                    const CreateHeader(),
                    const SizedBox(height: 16),
                    Obx(
                      () => CreateForm(
                        formKey: controller.formKey,
                        nameController: controller.nameController,
                        emailController: controller.emailController,
                        passwordController: controller.passwordController,
                        confirmPasswordController:
                            controller.confirmPasswordController,
                        isLoading: controller.isLoading.value,
                        isPasswordHidden: controller.isPasswordHidden.value,
                        isConfirmPasswordHidden:
                            controller.isConfirmPasswordHidden.value,
                        onCreateAccount: controller.createAccount,
                        onTogglePasswordVisibility:
                            controller.togglePasswordVisibility,
                        onToggleConfirmPasswordVisibility:
                            controller.toggleConfirmPasswordVisibility,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CreateFooter(onLogin: Get.back),
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
