import 'package:get/get.dart';
import 'package:mobile_app/modules/forget/controllers/forget_controller.dart';

class ForgotBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotController>(() => ForgotController());
  }
}