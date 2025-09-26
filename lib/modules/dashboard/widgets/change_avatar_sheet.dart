import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/modules/dashboard/controllers/dashboard_controller.dart';

class ChangeAvatarSheet extends GetView<DashboardController> {
  const ChangeAvatarSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Tirar Foto'),
            onTap: () {
              Get.back();
              controller.pickAndSaveImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Escolher da Galeria'),
            onTap: () {
              Get.back();
              controller.pickAndSaveImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}
