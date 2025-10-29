import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/modules/splash/controllers/redirect_controller.dart';

class RedirectScreen extends GetView<RedirectController> {
  const RedirectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<RedirectController>();

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}