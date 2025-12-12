import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final String textMessage;
  final String buttonText;
  final VoidCallback onCreateAccount;

  const Footer({
    super.key,
    required this.textMessage,
    required this.buttonText,
    required this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(textMessage),
        TextButton(onPressed: onCreateAccount, child: Text(buttonText)),
      ],
    );
  }
}
