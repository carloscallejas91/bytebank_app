import 'package:get/get.dart';
import 'package:mobile_app/modules/auth/ui/auth_screen.dart';
import 'package:mobile_app/modules/create/create_binding.dart';
import 'package:mobile_app/modules/create/ui/create_screen.dart';
import 'package:mobile_app/modules/forget/forget_binding.dart';
import 'package:mobile_app/modules/forget/ui/forget_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.AUTH;

  static final List<GetPage<dynamic>> routes = [
    GetPage(name: Routes.AUTH, page: () => const AuthScreen()),
    GetPage(
      name: Routes.CREATE_ACCOUNT,
      page: () => const CreateScreen(),
      binding: CreateBinding(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotScreen(),
      binding: ForgotBinding(),
    ),
  ];
}
