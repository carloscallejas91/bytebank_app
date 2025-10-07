import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import 'package:mobile_app/app/services/auth_service.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';

class AuthController extends GetxController {
  // Services
  final _authService = Get.find<AuthService>();
  final _snackBarService = Get.find<SnackBarService>();

  // Form
  final formKey = GlobalKey<FormState>();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Conditionals
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  //================================================================
  // Lifecycle Methods
  //================================================================

  @override
  void onReady() {
    super.onReady();

    _handleAuthChanged(_authService.currentUser);

    ever(_authService.user, _handleAuthChanged);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  //================================================================
  // Public Functions
  //================================================================

  Future<void> signInWithEmail() async {
    if (_isFormValid()) return;

    isLoading.value = true;

    try {
      final user = await _authService.signIn(
        email: emailController.text,
        password: passwordController.text,
      );

      if (user != null) {
        _clearForm();
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

  //================================================================
  // Private Functions
  //================================================================

  void _handleAuthChanged(User? firebaseUser) {
    if (firebaseUser != null && !_authService.isCreatingUser) {
      Get.offAllNamed(Routes.HOME);
    }  else if (firebaseUser == null) {
      Get.offAllNamed(Routes.AUTH);
    }
  }

  bool _isFormValid() {
    if (!formKey.currentState!.validate()) return true;

    return false;
  }

  void _clearForm() {
    emailController.clear();
    passwordController.clear();
  }
}
