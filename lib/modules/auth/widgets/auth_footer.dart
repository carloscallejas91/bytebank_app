import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  final VoidCallback onCreateAccount;

  const AuthFooter({super.key, required this.onCreateAccount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Não tem uma conta?'),
        TextButton(
          onPressed: onCreateAccount,
          child: const Text('Crie uma agora!'),
        ),
      ],
    );
  }
}
