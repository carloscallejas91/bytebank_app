import 'package:flutter/material.dart';
import 'package:mobile_app/modules/dashboard/widgets/avatar_widget.dart';
import 'package:mobile_app/modules/dashboard/widgets/user_info_widget.dart';

class HeaderWidget extends StatelessWidget {
  final String name;
  final String message;
  final String date;
  final String url;

  const HeaderWidget({
    super.key,
    required this.name,
    required this.message,
    required this.date,
    required this.url,
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
            AvatarWidget(url: url),
            UserInfoWidget(name: name, message: message, date: date),
          ],
        ),
      ),
    );
  }
}
