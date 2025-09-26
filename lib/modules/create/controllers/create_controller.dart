import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import 'package:mobile_app/app/services/auth_service.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';

class CreateController extends GetxController {
  // Services
  final _authService = Get.find<AuthService>();
  final _snackBarService = Get.find<SnackBarService>();

  // Form
  final formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Conditionals
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  //================================================================
  // Lifecycle Methods
  //================================================================

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  //================================================================
  // Public Functions
  //================================================================

  Future<void> createAccount() async {
    if (_isFormValid()) return;

    isLoading.value = true;

    try {
      final user = await _authService.createUser(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      if (user != null) {
        _clearForm();

        _snackBarService.showSuccess(
          title: 'Bem-vindo(a), ${user.displayName}!',
          message: 'Sua conta foi criada com sucesso.',
        );

        Get.offAllNamed(Routes.HOME);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);

      _snackBarService.showError(
        title: 'Erro ao Criar Conta',
        message: 'Ocorreu um erro, tente novamente!',
      );
    } catch (e) {
      _snackBarService.showError(
        title: 'Erro Inesperado',
        message: 'Ocorreu um erro. Por favor, tente novamente.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  //================================================================
  // Private Functions
  //================================================================

  bool _isFormValid() {
    if (!formKey.currentState!.validate()) return true;

    return false;
  }

  void _clearForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
