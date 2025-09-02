import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';

class AuthController extends GetxController {
  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Utils
  final SnackBarService snackBarService = Get.find();

  // Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Conditionals
  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;

  bool isFormValid() {
    if (!formKey.currentState!.validate()) return true;

    return false;
  }

  Future<void> signInWithEmail() async {
    Get.offAllNamed(Routes.HOME);
    // if (isFormValid()) return;
    //
    // isLoading.value = true;
    //
    // try {
    //   await _auth.signInWithEmailAndPassword(
    //     email: emailController.text.trim(),
    //     password: passwordController.text.trim(),
    //   );
    // } on FirebaseAuthException catch (e) {
    //   snackBarService.showError(title: 'Erro de Autenticação', message: e.message);
    // } finally {
    //   isLoading.value = false;
    // }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}