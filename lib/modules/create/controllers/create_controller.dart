import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/domain/usecases/create_user_usecase.dart';
import 'package:mobile_app/domain/usecases/map_auth_exception_to_message_usecase.dart';

class CreateController extends GetxController {
  // Services
  final _snackBarService = Get.find<SnackBarService>();

  // Use Cases
  final _createUserUseCase = Get.find<CreateUserUseCase>();
  final _mapAuthExceptionToMessageUseCase =
      Get.find<MapAuthExceptionToMessageUseCase>();

  // Form Key
  final formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // UI State
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // UI Actions
  void togglePasswordVisibility() {
    isPasswordHidden.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.toggle();
  }

  Future<void> createAccount() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    isLoading.value = true;

    await _executeCreateUserLogic();

    isLoading.value = false;
  }

  // Internal Logic & Private Methods
  Future<void> _executeCreateUserLogic() async {
    try {
      final user = await _createUserUseCase.call(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      if (user != null) {
        _handleAccountCreationSuccess(user);
      }
    } on FirebaseAuthException catch (e) {
      _handleAccountCreationError(e);
    } catch (e) {
      _handleAccountCreationError(e);
    }
  }

  void _handleAccountCreationSuccess(User user) {
    Get.back();

    _snackBarService.showSuccess(
      title: 'Sucesso!',
      message: 'Sua conta foi criada. Realize o login para continuar.',
    );
  }

  void _handleAccountCreationError(dynamic e) {
    if (e is FirebaseAuthException) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      final errorMessage = _mapAuthExceptionToMessageUseCase.call(e);
      _snackBarService.showError(
        title: 'Erro ao Criar Conta',
        message: errorMessage,
      );
    } else {
      debugPrint('Erro inesperado: $e');
      _snackBarService.showError(
        title: 'Erro Inesperado',
        message: 'Não foi possível criar sua conta. Tente mais tarde.',
      );
    }
  }
}
