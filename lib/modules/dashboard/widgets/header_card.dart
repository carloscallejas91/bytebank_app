import 'package:flutter/material.dart';
import 'package:mobile_app/modules/dashboard/widgets/avatar.dart';
import 'package:mobile_app/modules/dashboard/widgets/user_info.dart';

class HeaderCard extends StatelessWidget {
  final String name;
  final String message;
  final String date;
  final ImageProvider? backgroundImage;
  final VoidCallback? onAvatarTap;
  final bool isAvatarLoading;

  const HeaderCard({
    super.key,
    required this.name,
    required this.message,
    required this.date,
    this.backgroundImage,
    this.onAvatarTap,
    this.isAvatarLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            Avatar(
              backgroundImage: backgroundImage,
              onTap: onAvatarTap,
              isLoading: isAvatarLoading,
            ),
            UserInfo(name: name, message: message, date: date),
          ],
        ),
      ),
    );
  }
}
