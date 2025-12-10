import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/ui/widgets/custom_gradient_text.dart';

class UserInfo extends StatelessWidget {
  final String name;
  final String message;
  final String date;

  const UserInfo({
    super.key,
    required this.name,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Olá, ', style: Get.theme.textTheme.titleMedium),
            Text(
              name,
              style: Get.theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        CustomGradientText(gradientText: message),
        Text(date, style: Get.theme.textTheme.bodySmall),
      ],
    );
  }
}
