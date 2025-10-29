import 'package:flutter/material.dart';

class RedirectScreen extends StatelessWidget {
  const RedirectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
