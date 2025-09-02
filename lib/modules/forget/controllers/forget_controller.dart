import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';

class ForgotController extends GetxController {
  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Utils
  final SnackBarService snackBarService = Get.find();

  // Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  final emailController = TextEditingController();

  // Conditionals
  final RxBool isLoading = false.obs;

  bool isFormValid() {
    if (!formKey.currentState!.validate()) return true;

    return false;
  }

  Future<void> sendPasswordResetEmail() async {
    if (isFormValid()) return;

    isLoading.value = true;
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());

      snackBarService.showSuccess(
        title: 'Sucesso!',
        message:
        'Um e-mail de recuperação foi enviado para ${emailController.text.trim()}. Verifique '
            'sua caixa de entrada.',
      );

      Get.back();
    } on FirebaseAuthException catch (e) {
      snackBarService.showError(title: 'Erro', message: e.message);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}