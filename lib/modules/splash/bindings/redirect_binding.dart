import 'package:get/get.dart';
import 'package:mobile_app/modules/splash/controllers/redirect_controller.dart';

class RedirectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RedirectController>(() => RedirectController());
  }
}
