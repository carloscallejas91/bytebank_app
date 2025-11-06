import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';
import 'package:mobile_app/domain/usecases/map_auth_exception_to_message_usecase.dart';
import 'package:mobile_app/domain/usecases/sign_in_usecase.dart';

class AuthController extends GetxController {
  // Services
  final _snackBarService = Get.find<SnackBarService>();

  // Repositories
  final _authRepository = Get.find<IAuthRepository>();

  // Use Cases
  final _signInUseCase = Get.find<SignInUseCase>();
  final _mapAuthExceptionToMessageUseCase =
      Get.find<MapAuthExceptionToMessageUseCase>();

  // UI State
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  // Form
  final formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Stream Subscriptions
  StreamSubscription<User?>? _userSubscription;

  @override
  void onReady() {
    super.onReady();
    _userSubscription = _authRepository.userChanges.listen(_handleAuthChanged);
  }

  @override
  void onClose() {
    _userSubscription?.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // UI Actions
  void togglePasswordVisibility() {
    isPasswordHidden.toggle();
  }

  Future<void> signInWithEmail() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    isLoading.value = true;
    await _executeSignInLogic();
    isLoading.value = false;
  }

  // Navigation Actions
  void navigateToCreateAccount() {
    Get.toNamed(Routes.CREATE_ACCOUNT);
  }

  void navigateToForgotPassword() {
    Get.toNamed(Routes.FORGOT_PASSWORD);
  }

  // Internal Logic & Private Methods
  Future<void> _executeSignInLogic() async {
    try {
      final user = await _signInUseCase.call(
        email: emailController.text,
        password: passwordController.text,
      );
      if (user != null) {
        _handleSignInSuccess();
      }
    } on FirebaseAuthException catch (e) {
      _handleSignInError(e);
    } catch (e) {
      _handleSignInError(e);
    }
  }

  void _handleSignInSuccess() {
    // A navegação é gerenciada pelo RedirectController, então aqui só limpamos o formulário.
    _clearForm();
  }

  void _handleSignInError(dynamic e) {
    if (e is FirebaseAuthException) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      final errorMessage = _mapAuthExceptionToMessageUseCase.call(e);
      _snackBarService.showError(
        title: 'Erro de Autenticação',
        message: errorMessage,
      );
    } else {
      debugPrint('Erro inesperado: $e');
      _snackBarService.showError(
        title: 'Erro Inesperado',
        message: 'Ocorreu um erro ao tentar fazer login.',
      );
    }
  }

  void _handleAuthChanged(User? firebaseUser) {
    if (firebaseUser != null) {
      _clearForm();
    }
  }

  void _clearForm() {
    emailController.clear();
    passwordController.clear();
  }
}
