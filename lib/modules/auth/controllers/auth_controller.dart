import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import 'package:mobile_app/app/services/auth_service.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';

class AuthController extends GetxController {
  // Services
  final AuthService _authService = Get.find();
  final SnackBarService _snackBarService = Get.find();

  // Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Conditionals
  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;

  @override
  void onReady() {
    super.onReady();

    _handleAuthChanged(_authService.currentUser);

    ever(_authService.user, _handleAuthChanged);
  }

  void _handleAuthChanged(User? firebaseUser) {
    if (firebaseUser != null) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.AUTH);
    }
  }

  bool isFormValid() {
    if (!formKey.currentState!.validate()) return true;

    return false;
  }

  Future<void> signInWithEmail() async {
    if (isFormValid()) return;

    isLoading.value = true;

    try {
      final user = await _authService.signIn(
        email: emailController.text,
        password: passwordController.text,
      );

      if (user != null) {
        clearForm();
        Get.offAllNamed(Routes.HOME);
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

  void clearForm() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
