import 'package:get/get.dart';
import 'package:mobile_app/app/services/auth_service.dart';
import 'package:mobile_app/app/services/database_service.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/app/services/storage_service.dart';
import 'package:mobile_app/modules/auth/controllers/auth_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put<SnackBarService>(SnackBarService());
    Get.put<AuthService>(AuthService());
    Get.put<DatabaseService>(DatabaseService());
    Get.put<StorageService>(StorageService());

    // Controllers
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}