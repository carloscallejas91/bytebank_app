import 'package:get/get.dart';
import 'package:mobile_app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mobile_app/modules/transaction_form/controllers/transaction_form_controller.dart';
import 'package:mobile_app/modules/home/controllers/home_controller.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<TransactionController>(() => TransactionController(), fenix: true);
    Get.lazyPut<TransactionFormController>(() => TransactionFormController(), fenix: true);
  }
}