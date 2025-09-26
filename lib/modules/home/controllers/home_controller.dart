import 'package:get/get.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import 'package:mobile_app/app/services/auth_service.dart';
import 'package:mobile_app/app/ui/widgets/app_dialogs.dart';

class HomeController extends GetxController {
  // Services
  final _authService = Get.find<AuthService>();

  // Others
  final RxInt selectedIndex = 0.obs;

  //================================================================
  // Public Functions
  //================================================================

  void changePage(int index) {
    selectedIndex.value = index;
  }

  void signOut() {
    AppDialogs.showConfirmationDialog(
      title: 'Sair',
      message: 'Você tem certeza que deseja sair do aplicativo?',
      onConfirm: () async {
        await _authService.signOut();
      },
    );
  }
}
