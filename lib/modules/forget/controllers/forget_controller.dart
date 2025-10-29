import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/domain/usecases/send_password_reset_email_usecase.dart';

class ForgetController extends GetxController {
  // Services
  final _snackBarService = Get.find<SnackBarService>();

  // Use Cases
  final _sendPasswordResetEmailUseCase =
      Get.find<SendPasswordResetEmailUseCase>();

  // Form
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final emailController = TextEditingController();

  // UI State
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> sendPasswordResetEmail() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    isLoading.value = true;

    try {
      await _sendPasswordResetEmailUseCase.call(email: emailController.text);

      Get.back();

      _snackBarService.showSuccess(
        title: 'Sucesso!',
        message:
            'Um e-mail de recuperação foi enviado para ${emailController.text.trim()}. '
            'Verifique sua caixa de entrada.',
      );

      emailController.clear();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      _snackBarService.showError(
        title: 'Erro',
        message: 'Ocorreu um erro, verifique o e-mail e tente novamente!',
      );
    } catch (e) {
      debugPrint('Falha inesperada ao enviar e-mail de recuperação: $e');
      _snackBarService.showError(
        title: 'Erro Inesperado',
        message: 'Não foi possível completar a solicitação. Tente mais tarde.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
