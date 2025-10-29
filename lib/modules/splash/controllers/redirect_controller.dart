import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';

class RedirectController extends GetxController {
  final _authRepository = Get.find<IAuthRepository>();
  StreamSubscription<User?>? _userSubscription;

  @override
  void onReady() {
    super.onReady();
    _userSubscription = _authRepository.userChanges.listen(_handleAuthChanged);
    // A verificação inicial também é feita pelo listener, pois o `userChanges`
    // emite o estado atual assim que é ouvido.
  }

  @override
  void onClose() {
    _userSubscription?.cancel();
    super.onClose();
  }

  void _handleAuthChanged(User? firebaseUser) {
    // Um pequeno delay para evitar flashes de tela durante a transição inicial
    Future.delayed(const Duration(milliseconds: 500), () {
      if (firebaseUser != null) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.AUTH);
      }
    });
  }
}
