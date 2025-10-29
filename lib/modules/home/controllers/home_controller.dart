import 'package:get/get.dart';
import 'package:mobile_app/app/ui/widgets/app_dialogs.dart';
import 'package:mobile_app/domain/usecases/sign_out_usecase.dart';

class HomeController extends GetxController {
  // Use Cases
  final _signOutUseCase = Get.find<SignOutUseCase>();

  // State
  final RxInt selectedIndex = 0.obs;

  void changePage(int index) {
    selectedIndex.value = index;
  }

  void signOut() {
    AppDialogs.showConfirmationDialog(
      title: 'Sair',
      message: 'Você tem certeza que deseja sair do aplicativo?',
      onConfirm: () async {
        await _signOutUseCase.call();
      },
    );
  }
}
