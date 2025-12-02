import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final ImageProvider? backgroundImage;
  final VoidCallback? onTap;
  final bool isLoading;

  const AvatarWidget({
    super.key,
    this.backgroundImage,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 35,
        backgroundColor: theme.colorScheme.surfaceContainerHigh,
        child: isLoading
            ? const CircularProgressIndicator(strokeWidth: 2)
            : _buildAvatarContent(theme),
      ),
    );
  }

  Widget _buildAvatarContent(ThemeData theme) {
    if (backgroundImage != null) {
      return CircleAvatar(radius: 35, backgroundImage: backgroundImage);
    } else {
      return Icon(
        Icons.person,
        size: 35,
        color: theme.colorScheme.onSurfaceVariant,
      );
    }
  }
}
