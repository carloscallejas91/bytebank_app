import 'package:get/get.dart';
import 'package:mobile_app/modules/auth/auth_binding.dart';
import 'package:mobile_app/modules/auth/ui/auth_screen.dart';
import 'package:mobile_app/modules/create/create_binding.dart';
import 'package:mobile_app/modules/create/ui/create_screen.dart';
import 'package:mobile_app/modules/forget/forget_binding.dart';
import 'package:mobile_app/modules/forget/ui/forget_screen.dart';
import 'package:mobile_app/modules/home/home_binding.dart';
import 'package:mobile_app/modules/home/ui/home_screen.dart';
import 'package:mobile_app/modules/redirect/bindings/redirect_binding.dart';
import 'package:mobile_app/modules/redirect/ui/redirect_screen.dart';
part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const RedirectScreen(),
      binding: RedirectBinding(),
    ),
    GetPage(
      name: Routes.AUTH,
      page: () => const AuthScreen(),
      binding: AuthBinding(),
    ),
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
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}
