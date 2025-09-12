import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import 'package:mobile_app/app/services/auth_service.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';

class CreateController extends GetxController {
  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Utils
  final AuthService _authService = Get.find();
  final SnackBarService _snackBarService = Get.find();

  // Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Conditionals
  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;

  bool isFormValid() {
    if (!formKey.currentState!.validate()) return true;

    return false;
  }

  Future<void> createAccount() async {
    if (isFormValid()) return;

    isLoading.value = true;

    try {
      final user = await _authService.createUser(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      if (user != null) {
        _snackBarService.showSuccess(
          title: 'Bem-vindo(a), ${user.displayName}!',
          message: 'Sua conta foi criada com sucesso.',
        );

        Get.offAllNamed(Routes.HOME);
      }
    } on FirebaseAuthException catch (e) {
      _snackBarService.showError(
        title: 'Erro ao Criar Conta',
        message: e.message,
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

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
