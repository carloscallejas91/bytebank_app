import 'package:flutter/material.dart';

class CreateFooter extends StatelessWidget {
  final VoidCallback onLogin;

  const CreateFooter({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Já tenho uma conta?'),
        TextButton(onPressed: onLogin, child: const Text('Faça login')),
      ],
    );
  }
}
