import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/services/auth_service.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';

class ForgotController extends GetxController {
  // Services
  final _authService = Get.find<AuthService>();
  final _snackBarService = Get.find<SnackBarService>();

  // Form
  final formKey = GlobalKey<FormState>();

  // Controllers
  final emailController = TextEditingController();

  // Conditionals
  final isLoading = false.obs;

  //================================================================
  // Lifecycle Methods
  //================================================================

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  //================================================================
  // Public Functions
  //================================================================

  Future<void> sendPasswordResetEmail() async {
    if (_isFormValid()) return;

    isLoading.value = true;

    try {
      await _authService.sendPasswordResetEmail(email: emailController.text);

      Get.back();

      _snackBarService.showSuccess(
        title: 'Sucesso!',
        message:
            'Um e-mail de recuperação foi enviado '
            'para ${emailController.text.trim()}. Verifique '
            'sua caixa de entrada.',
      );

      _clearForm();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);

      _snackBarService.showError(
        title: 'Erro',
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

  //================================================================
  // Private Functions
  //================================================================

  bool _isFormValid() {
    if (!formKey.currentState!.validate()) return true;

    return false;
  }

  void _clearForm() {
    emailController.clear();
  }
}
