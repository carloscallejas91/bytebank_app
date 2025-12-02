import 'package:flutter/material.dart';
import 'package:mobile_app/modules/dashboard/widgets/avatar_widget.dart';
import 'package:mobile_app/modules/dashboard/widgets/user_info_widget.dart';

class HeaderWidget extends StatelessWidget {
  final String name;
  final String message;
  final String date;
  final ImageProvider? backgroundImage; // Mudança aqui: de String url para ImageProvider
  final VoidCallback? onAvatarTap;
  final bool isAvatarLoading;

  const HeaderWidget({
    super.key,
    required this.name,
    required this.message,
    required this.date,
    this.backgroundImage, // Mudança aqui: de required para opcional (pode ser null se não houver foto)
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
            AvatarWidget(
              backgroundImage: backgroundImage, // Passando o ImageProvider
              onTap: onAvatarTap,
              isLoading: isAvatarLoading,
            ),
            UserInfoWidget(name: name, message: message, date: date),
          ],
        ),
      ),
    );
  }
}
