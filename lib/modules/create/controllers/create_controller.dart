import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/domain/usecases/create_user_usecase.dart';

class CreateController extends GetxController {
  // Services
  final _snackBarService = Get.find<SnackBarService>();

  // Use Cases
  final _createUserUseCase = Get.find<CreateUserUseCase>();

  // Form
  final formKey = GlobalKey<FormState>();

  // Text Controllers
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

  Future<void> createAccount() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    isLoading.value = true;

    try {
      final user = await _createUserUseCase.call(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      if (user != null) {
        Get.back(); // Volta para a tela de login
        _snackBarService.showSuccess(
          title: 'Sucesso!',
          message: 'Sua conta foi criada. Realize o login para continuar.',
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      _snackBarService.showError(
        title: 'Erro ao Criar Conta',
        message: 'Ocorreu um erro, verifique os dados e tente novamente!',
      );
    } catch (e) {
      debugPrint('Falha inesperada ao criar conta: $e');
      _snackBarService.showError(
        title: 'Erro Inesperado',
        message: 'Não foi possível criar sua conta. Tente mais tarde.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.toggle();
  }
}
