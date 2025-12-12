import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Avatar extends StatelessWidget {
  final ImageProvider? backgroundImage;
  final VoidCallback? onTap;
  final bool isLoading;

  const Avatar({
    super.key,
    this.backgroundImage,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 35,
        backgroundColor: Get.theme.colorScheme.surfaceContainerHigh,
        child: isLoading
            ? const CircularProgressIndicator(strokeWidth: 2)
            : _buildAvatarContent(),
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (backgroundImage != null) {
      return CircleAvatar(radius: 35, backgroundImage: backgroundImage);
    } else {
      return Icon(
        Icons.person,
        size: 35,
        color: Get.theme.colorScheme.onSurfaceVariant,
      );
    }
  }
}
