import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Header extends StatelessWidget {
  final String textMessage;
  final String textBoldMessage;
  final String description;

  const Header({
    super.key,
    required this.textMessage,
    required this.textBoldMessage,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildWelcomeText(), Text(description)],
    );
  }

  Widget _buildWelcomeText() {
    return Row(
      children: [
        Text(textMessage, style: Get.theme.textTheme.titleLarge),
        Text(
          textBoldMessage,
          style: Get.theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
