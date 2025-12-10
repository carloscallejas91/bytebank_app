import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChangeAvatarSheet extends StatelessWidget {
  final String cameraOptionTitle;
  final String galleryOptionTitle;
  final ValueChanged<ImageSource> onPickImage;

  const ChangeAvatarSheet({
    super.key,
    required this.cameraOptionTitle,
    required this.galleryOptionTitle,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: Text(cameraOptionTitle),
            onTap: () {
              Get.back();
              onPickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: Text(galleryOptionTitle),
            onTap: () {
              Get.back();
              onPickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}
