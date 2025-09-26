import 'package:flutter/material.dart';
import 'package:mobile_app/app/ui/widgets/custom_gradient_text.dart';

class UserInfoWidget extends StatelessWidget {
  final String name;
  final String message;
  final String date;

  const UserInfoWidget({
    super.key,
    required this.name,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Olá, ', style: theme.textTheme.titleMedium),
            Text(
              name,
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        CustomGradientText(gradientText: message),
        Text(date, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
