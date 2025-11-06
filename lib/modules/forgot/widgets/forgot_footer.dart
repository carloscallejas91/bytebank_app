import 'package:flutter/material.dart';

class ForgotFooter extends StatelessWidget {
  final VoidCallback onLogin;

  const ForgotFooter({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Lembrou sua senha?'),
        TextButton(onPressed: onLogin, child: const Text('Faça login')),
      ],
    );
  }
}
