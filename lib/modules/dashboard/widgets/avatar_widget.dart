import 'dart:io';

import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String url;
  final VoidCallback? onTap;
  final bool isLoading;

  const AvatarWidget({
    super.key,
    required this.url,
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
            : _buildAvatarContent(context),
      ),
    );
  }

  Widget _buildAvatarContent(BuildContext context) {
    final hasUrl = url.isNotEmpty;
    final isNetworkImage = hasUrl && url.startsWith('http');

    if (hasUrl) {
      return CircleAvatar(
        radius: 35,
        backgroundImage: isNetworkImage
            ? NetworkImage(url)
            : FileImage(File(url)) as ImageProvider,
      );
    } else {
      return Icon(
        Icons.person,
        size: 40,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );
    }
  }
}
