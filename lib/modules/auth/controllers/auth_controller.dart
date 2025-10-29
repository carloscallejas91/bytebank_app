import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/domain/usecases/sign_in_usecase.dart';

class AuthController extends GetxController {
  // Services & UseCases
  final _snackBarService = Get.find<SnackBarService>();
  final _signInUseCase = Get.find<SignInUseCase>();

  // Form
  final formKey = GlobalKey<FormState>();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Conditionals
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> signInWithEmail() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    isLoading.value = true;

    try {
      final user = await _signInUseCase.call(
        email: emailController.text,
        password: passwordController.text,
      );
      // Se o login for bem-sucedido, o RedirectController (que ainda está ouvindo)
      // detectará a mudança de estado e redirecionará para a home.
      if (user != null) {
        _clearForm();
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      _snackBarService.showError(
        title: 'Erro de Autenticação',
        message: 'Ocorreu um erro, tente novamente!',
      );
    } catch (e) {
      _snackBarService.showError(
        title: 'Erro Inesperado',
        message: 'Ocorreu um erro ao tentar fazer login.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void _clearForm() {
    emailController.clear();
    passwordController.clear();
  }
}
