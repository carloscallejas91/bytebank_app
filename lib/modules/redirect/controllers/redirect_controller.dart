import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';

class RedirectController extends GetxService {
  final _authRepository = Get.find<IAuthRepository>();
  StreamSubscription<User?>? _userSubscription;

  @override
  void onInit() {
    super.onInit();
    _userSubscription = _authRepository.userChanges.listen(_handleAuthChanged);
  }

  @override
  void onClose() {
    _userSubscription?.cancel();
    super.onClose();
  }

  void _handleAuthChanged(User? firebaseUser) {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (firebaseUser != null) {
        // Se a rota atual não for a HOME, navega para ela.
        if (Get.currentRoute != Routes.HOME) {
          Get.offAllNamed(Routes.HOME);
        }
      } else {
        // Se a rota atual não for a AUTH, navega para ela.
        if (Get.currentRoute != Routes.AUTH) {
          Get.offAllNamed(Routes.AUTH);
        }
      }
    });
  }
}
