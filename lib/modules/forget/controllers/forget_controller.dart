import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/domain/usecases/map_auth_exception_to_message_usecase.dart';
import 'package:mobile_app/domain/usecases/send_password_reset_email_usecase.dart';

class ForgetController extends GetxController {
  // Services
  final _snackBarService = Get.find<SnackBarService>();

  // Use Cases
  final _sendPasswordResetEmailUseCase =
      Get.find<SendPasswordResetEmailUseCase>();
  final _mapAuthExceptionToMessageUseCase =
      Get.find<MapAuthExceptionToMessageUseCase>();

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

  // UI Actions
  Future<void> sendPasswordResetEmail() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    isLoading.value = true;

    await _executePasswordResetLogic();

    isLoading.value = false;
  }

  // Internal Logic & Private Methods
  Future<void> _executePasswordResetLogic() async {
    try {
      await _sendPasswordResetEmailUseCase.call(email: emailController.text);
      _handlePasswordResetSuccess();
    } on FirebaseAuthException catch (e) {
      _handlePasswordResetError(e);
    } catch (e) {
      _handlePasswordResetError(e);
    }
  }

  void _handlePasswordResetSuccess() {
    Get.back();
    _snackBarService.showSuccess(
      title: 'Sucesso!',
      message:
          'Um e-mail de recuperação foi enviado para ${emailController.text.trim()}. '
          'Verifique sua caixa de entrada.',
    );
    emailController.clear();
  }

  void _handlePasswordResetError(dynamic e) {
    if (e is FirebaseAuthException) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      final errorMessage = _mapAuthExceptionToMessageUseCase.call(e);
      _snackBarService.showError(title: 'Erro', message: errorMessage);
    } else {
      debugPrint('Falha inesperada ao enviar e-mail de recuperação: $e');
      _snackBarService.showError(
        title: 'Erro Inesperado',
        message: 'Não foi possível completar a solicitação. Tente mais tarde.',
      );
    }
  }
}
